extends VehicleBody3D
class_name BaseCarScript

signal race_finished(car_name: String, total_time: float)

@onready var car_state_machine = $CarStateMachine
@onready var start_level = preload("res://Scenes/Menu/player_select.tscn")
@onready var engine_sound = $EngineSFX
@export var LFW: VehicleWheel3D
@export var RFW: VehicleWheel3D 
@export var LBW: VehicleWheel3D
@export var RBW: VehicleWheel3D
@export var rocket_Scene = load("res://Scenes/Powerups/Rocket_powerup.tscn")

@onready var firenode =$Exhaust/FireNode
@onready var ghost_timer = $Ghost_Timer
@onready var icon = $Car_ui
@onready var damage_area = $DamageArea
@onready var exhaust = $Exhaust
@onready var respawn_point = $RespawnPoint
@onready var respawn_timer = $RespawnPoint/Timer
@onready var on_road_cast = $OnRoadCast

@export var checkpoint_manager: CheckpointManager = CheckpointManager.new()
@export var lap_timer: LapTimer = LapTimer.new()

@export_group("Bilvariabler")
@export var Acceleration = 1500
var Top_Speed = 40
@export var boostSpeed = 0
@export var traction = 3.0
@export var weight = 300

@export_group("Bildelar")
@export var collisionMesh: CollisionShape3D
@export var carMesh: MeshInstance3D
@export var ghostMesh: MeshInstance3D
@export var exhausPosition: Node3D
@export var car_rocketRay: RayCast3D
@export var animation_player: AnimationPlayer

# Variabler som används i states
var slidepower := 0.0
var look_at: Vector3
@export var powerUps = null
var checkpoint = ""
var powerUpNum := 0
var player_index := 0

var MAX_STEER := 0.3
var MAX_TOPSPEED = 1
var ENGINE_POWER := 1500

var WHEEL_POWER =1
var WHEEL_STEER = 1
var WHEEL_TRACTION = 1.0
var WHEEL_RADIUS = 0.7
var DEADZONE := 0.1

var current_wheel_data: WheelData = null

var active_checkpoint := 11
var active_lap = 1

# Ny variabel som styrningen uppdaterar
var steering_input := 0.0

func _ready():
	# Checkpoints
	var root = get_tree().get_current_scene()
	var checkPoint_parent = _find_checkpoints(root)
	if checkPoint_parent == null:
		push_error("🚨 Kunde inte hitta 'Checkpoints'")
		return

	checkpoint_manager.setup_from_node(checkPoint_parent)
	for checkPoint in checkPoint_parent.get_children():
		if checkPoint is CheckpointArea:
			checkPoint.connect("checkpoint_entered", Callable(self, "on_checkpoint_entered"))
			
	if Global.selected_wheel_data:
		apply_wheel_data(Global.selected_wheel_data[player_index])

	# Övrig setup
	if exhausPosition:
		exhaust.global_transform.origin = exhausPosition.global_transform.origin

	mass = weight
	
	powerUps = get_node("/root/PowerUps")
	checkpoint = get_parent().get_node("/root/Checkpoints")
	look_at = global_position
	# Setup state machine
	car_state_machine.setup_car(self)
	# Starta varvräknare
	lap_timer.start()
	
func apply_wheel_data(data: WheelData):
	for wheel in [LFW, RFW, LBW, RBW]:
		# Ta bort tidigare mesh om den finns (för att undvika dubbletter)
		for child in wheel.get_children():
			if child is MeshInstance3D:
				child.queue_free()

		var mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = data.wheel_mesh  # <-- rätt namn här!
		wheel.add_child(mesh_instance)
		
		WHEEL_POWER = data.acceleration_multiplier
		traction = data.grip
		engine_force *= data.acceleration_multiplier
		WHEEL_RADIUS = data.radius
		MAX_TOPSPEED = Top_Speed* data.top_speed_multiplier
		
		Acceleration *= data.acceleration_multiplier
		var a =2
		
func _physics_process(delta):
	active_lap = checkpoint_manager.lap_count
	# Låt state maskinen göra sina saker (t.ex. uppdatera engine_force, brake och steering)
	car_state_machine._physics_process(delta)#
	## Applicera styrvinkel till framhjulen
	LFW.steering = steering_input
	RFW.steering = steering_input

func _find_checkpoints(node: Node) -> Node:
	if node.name == "Checkpoints":
		return node
	for child in node.get_children():
		var found = _find_checkpoints(child)
		if found:
			return found
	return null
	
func on_checkpoint_enter(area):
	checkpoint_check(area)

func create_convex_collision_shape(mesh: Mesh) -> ConvexPolygonShape3D:
	var tool = MeshDataTool.new()
	tool.create_from_surface(mesh, 0)
	var vertices = []
	for i in range(tool.get_vertex_count()):
		vertices.append(tool.get_vertex(i))
	var shape = ConvexPolygonShape3D.new()
	shape.set_points(vertices)
	return shape

func on_powerup_pickup(area):
	powerUpNum = powerUps.get_powerup()
	icon.set_icon_visible(powerUpNum)

func checkpoint_check(area):
	var chk_int = int(area.name)
	var result = checkpoint_manager.pass_checkpoint(chk_int)

	if not result.ok:
		print("⚠️ Fel checkpoint. Förväntade:", checkpoint_manager.current_index, "men fick:", chk_int)
		return

	print("✅ Checkpoint ok:", chk_int, "/", checkpoint_manager.total_checkpoints)

	if result.lap_finished:
		var lap_time = lap_timer.lap_completed()
		print("🏁 Varv", checkpoint_manager.lap_count, "klar på", lap_time, "s")

	if result.finished:
		var total_time = lap_timer.total_time
		var overlay = preload("res://Scenes/Menu/player_result_overlay.tscn").instantiate()
		overlay.set_time(total_time)
		get_viewport().add_child(overlay)
		set_process(false)
		set_physics_process(false)

		var car_name = "Player: "+str(player_index)
		if car_name == "":
			car_name = "No_Name_%d" % player_index
		Global.add_race_result(car_name, total_time)

func _on_respawn_timer_timeout():
	if on_road_cast.check_ground():
		respawn_point.position = exhaust.global_position
		respawn_timer.start(1)

func _on_ghost_timer_timeout():
	# Återställ efter t.ex. ghost mode
	firenode.stop_fire()
	carMesh.visible = true
	ghostMesh.visible = false
	set_collision_layer_value(4, 1)
	set_collision_mask_value(4, 1)
	boostSpeed =0
