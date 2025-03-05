extends VehicleBody3D
class_name BaseCarScript

@onready var start_level = preload("res://Scenes/Menu/player_select.tscn") as PackedScene
@onready var checkerpointer = $Checkerpointer
@onready var camera_pivot = $camera_pivot
@onready var camera_3d = $camera_pivot/Camera3D
@onready var engine_sound = $EngineSFX
@onready var LFW = $VehicleWheel3D
@onready var RFW = $RFW
@onready var LBW = $VehicleWheel3D2
@onready var RBW = $RBW
@onready var fire_car = $"."
@onready var timer = $Timer
@onready var icon = $Car_ui
@onready var damage_area = $DamageArea
@onready var exhaust = $Exhaust
@onready var state = $state
@onready var respawn_point = $RespawnPoint
@onready var respawn_timer = $RespawnPoint/Timer
@onready var on_road_cast = $OnRoadCast

@export_group("Bilvariabler")
@export var Acceleration = 1500
@export var Top_Speed = 550
@export var boostSpeed = 0
@export var traction = 3
@export var weight = 300

@export_group("Bildelar")
@export var collisionMesh: CollisionShape3D
@export var carMesh: MeshInstance3D
@export var RealcarMesh: MeshInstance3D
@export var ghostMesh: MeshInstance3D
@export var exhausPosition: Node3D  # Exportera position för avgasrör
@export var car_rocketRay: RayCast3D
@export var animation_player: AnimationPlayer



var active_checkpoint = 1
var active_lap = 1

var MAX_STEER = 0.3
var ENGINE_POWER = 1500
var DEADZONE = 0.1
var powerUpNum = 0
var player_index = 0

var look_at
var slidepower = 0
var powerUps = null
var checkpoint = ""

func _ready():
	if carMesh and carMesh.mesh:
		# Skapa kollision för bilens kropp
		var collision_shape_body = CollisionShape3D.new()
		var shape_body = create_convex_collision_shape(carMesh.mesh)
		collision_shape_body.shape = shape_body
		self.add_child(collision_shape_body)

		# Skapa kollision för DamageArea
		var collision_shape_damage = CollisionShape3D.new()
		var shape_damage = create_convex_collision_shape(carMesh.mesh)
		collision_shape_damage.shape = shape_damage
		damage_area.add_child(collision_shape_damage)
	
	if exhausPosition:
		exhaust.global_transform.origin = exhausPosition.global_transform.origin
	
	mass = weight      
	powerUps = get_node("/root/PowerUps")
	checkpoint = get_parent().get_node("/root/check_points")
	look_at = global_position
	steering = 0    

func create_convex_collision_shape(mesh: Mesh) -> ConvexPolygonShape3D:
	var tool = MeshDataTool.new()
	tool.create_from_surface(mesh, 0)
	var vertices = []
	for i in range(tool.get_vertex_count()):
		vertices.append(tool.get_vertex(i))
	var shape = ConvexPolygonShape3D.new()
	shape.set_points(vertices)
	return shape

func _physics_process(delta):   
	ENGINE_POWER = Acceleration
	# Check input actions
	var steering_input = Input.get_joy_axis(player_index, 0)
	var throttle_action = "player" + str(player_index + 1) + "_throttle"
	var drift_action = "player" + str(player_index + 1) + "_drift"
	var action_action = "player" + str(player_index + 1) + "_action"
	var brake_action = "player" + str(player_index + 1) + "_brake"
	var reset_action = "player" + str(player_index + 1) + "_reset"
	
	if abs(steering_input) < DEADZONE:
		steering_input = 0      
	steering = move_toward(steering, steering_input * -1 * (MAX_STEER * state.steer), delta * 2.5)
	if ((RBW.get_rpm() < Top_Speed && (RBW.get_rpm() > -Top_Speed)) || (boostSpeed > 1)):
		#print("Gasning!")
		engine_force = Input.get_joy_axis(player_index,  5) * ENGINE_POWER + boostSpeed + slidepower
	else:
		engine_force = 0
	
	if Input.is_action_pressed(reset_action):
		self.global_position = respawn_point.global_position

func on_checkpoint_enter(area):
	checkpoint_check(area)

func on_powerup_pickup(area):
	powerUpNum = powerUps.get_powerup()
	icon.set_icon_visible(powerUpNum)
	
func set_boost_speed(speed):
	boostSpeed = speed

func checkpoint_check(area):
	var checknum = area.get_parent().get_parent()
	var checkchild = checknum.get_child_count() - 3
	var ChkInt = int(String(area.name))
	print("num checkpoints: ", checkchild)
	print("checkpointnr: ", active_checkpoint)
	print("Lapnr: ", active_lap)
	if ChkInt != checkchild:
		if ChkInt == active_checkpoint:
			active_checkpoint += 1
			print("Active checkpoint: ",active_checkpoint)
		else:
			print("Already been here")
	if ChkInt == checkchild - 1 and active_checkpoint == checkchild:
		active_checkpoint = 1
		active_lap += 1
		if active_lap == 4:
			print("Woho you finished the race!")			
			freeze=1
		else:
			print("Woho new lap!")
			
func _on_timer_timeout():
	if on_road_cast.check_ground():
		respawn_point.position = exhaust.global_position
		respawn_timer.start(1)
