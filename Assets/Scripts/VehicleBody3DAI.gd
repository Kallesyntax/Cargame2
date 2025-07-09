extends Node3D

@onready var vehicle_body: VehicleBody3D = %VehicleBody3D
@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D
@onready var obstacle_detection: Area3D = %DetectionArea
@onready var danger_area: Node3D = %DangerArea  # Dynamisk hinderzon
@onready var RBW = %RBW
@onready var timer: Timer = Timer.new()

var checkpoints_node = null
var checkpoints_positions = []
var active_checkpoint_index = 0

@export_group("Bilvariabler")
@export var Acceleration = 1500
@export var Top_Speed = 550
@export var weight = 300
@export var traction = 3



const REACH_TOLERANCE: float = 3.0
var MAX_STEER = 0.6
var DEADZONE = 0.1
var ENGINE_POWER = 0

var active_obstacles = []
var is_avoiding = false

func _ready():
	if vehicle_body == null or navigation_agent == null or obstacle_detection == null or danger_area == null or RBW == null:
		print("Error: Required nodes are missing!")
		return

	setup_obstacle_detection()
	vehicle_body.mass = weight

	checkpoints_node = find_checkpoints_node(get_parent())
	if checkpoints_node != null:
		gather_all_children_positions()
		if checkpoints_positions.size() > 0:
			set_next_target()

	add_child(timer)
	timer.wait_time = 1.0
	timer.connect("timeout", Callable(self, "update_navigation_path"))
	timer.start()

func setup_obstacle_detection():
	obstacle_detection.collision_mask = (1 << 5)  # Lager 3 används för hinder
	obstacle_detection.connect("body_entered", Callable(self, "_on_obstacle_detected"))
	obstacle_detection.connect("body_exited", Callable(self, "_on_obstacle_cleared"))

func _physics_process(delta: float):
	if navigation_agent == null:
		return

	if is_avoiding:
		handle_avoidance(delta)
		return

	var next_point = navigation_agent.get_next_path_position()
	if next_point != null:
		var vehicle_position = vehicle_body.global_transform.origin
		if vehicle_position.distance_to(next_point) < REACH_TOLERANCE:
			goto_next_checkpoint()
		else:
			move_towards_point(next_point, delta)

func handle_avoidance(delta: float):
	var danger_center = danger_area.global_transform.origin
	var vehicle_position = vehicle_body.global_transform.origin
	var escape_direction = (vehicle_position - danger_center).normalized()
	var new_target = vehicle_position + escape_direction * 10.0
	navigation_agent.set_target_position(new_target)
	move_towards_point(new_target, delta)

func _on_obstacle_detected(body):
	if body.collision_layer & (1 << 3) and body not in active_obstacles:
		active_obstacles.append(body)
		update_danger_area()

func _on_obstacle_cleared(body):
	if body in active_obstacles:
		active_obstacles.erase(body)
		update_danger_area()

func update_danger_area():
	if active_obstacles.size() == 0:
		reset_danger_area()
		is_avoiding = false
		return

	var min_pos = active_obstacles[0].global_transform.origin
	var max_pos = active_obstacles[0].global_transform.origin

	for obstacle in active_obstacles:
		var pos = obstacle.global_transform.origin
		min_pos = min_pos.min(pos)
		max_pos = max_pos.max(pos)

	var center_pos = (min_pos + max_pos) / 2
	var extents = (max_pos - min_pos) / 2 + Vector3(2, 2, 2)
	danger_area.global_transform.origin = center_pos
	(danger_area.get_node("CollisionShape3D").shape as BoxShape3D).extents = extents
	is_avoiding = true

func reset_danger_area():
	danger_area.global_transform.origin = vehicle_body.global_transform.origin
	(danger_area.get_node("CollisionShape3D").shape as BoxShape3D).extents = Vector3.ZERO

func move_towards_point(next_point: Vector3, delta: float):
	var vehicle_position = vehicle_body.global_transform.origin
	var direction = (next_point - vehicle_position).normalized()
	var forward = -vehicle_body.global_transform.basis.z.normalized()
	var cross = forward.cross(direction)

	vehicle_body.steering = lerp(vehicle_body.steering, clamp(-cross.y, -1, 1) * MAX_STEER, delta * traction)

	var speed = RBW.get_rpm()
	if abs(speed) < Top_Speed:
		vehicle_body.engine_force = Acceleration
		vehicle_body.brake = 0
	else:
		vehicle_body.engine_force = 0
		vehicle_body.brake = 10

func goto_next_checkpoint():
	if checkpoints_positions.size() == 0:
		return

	active_checkpoint_index += 1
	if active_checkpoint_index >= checkpoints_positions.size():
		active_checkpoint_index = 0
	set_next_target()

func set_next_target():
	if checkpoints_positions.size() == 0:
		return
	navigation_agent.set_target_position(checkpoints_positions[active_checkpoint_index])

func update_navigation_path():
	if checkpoints_positions.size() == 0:
		return
	navigation_agent.set_target_position(checkpoints_positions[active_checkpoint_index])

func find_checkpoints_node(parent: Node) -> Node:
	for child in parent.get_children():
		if child.name == "Checkpoints":
			return child
	return null

func gather_all_children_positions():
	checkpoints_positions.clear()
	for child in checkpoints_node.get_children():
		checkpoints_positions.append(child.global_transform.origin)
