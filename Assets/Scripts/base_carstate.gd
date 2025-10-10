class_name CarBaseState

extends Node

signal transition(new_state_name: StringName)

enum States {IDLE, DRIVING, DRIFTING, POWERUP, DAMAGE}

var state = States.IDLE

@export var fire: Node
@export var root_node: VehicleBody3D
@export var LFW: VehicleWheel3D
@export var RFW: VehicleWheel3D
@export var LBW: VehicleWheel3D
@export var RBW: VehicleWheel3D

@onready var vehicle_body_3d = $".."
@onready var engine_sound = $"../EngineSFX"
@onready var smoke_emitt = $"../Exhaust/Smoke"
@onready var icon = $"../Car_ui"
@onready var powerUpID = $".."
@onready var timer = $"../Timer"
@onready var timer_damage = $TimerDamage

var rocket_Scene = load("res://Scenes/Powerups/Rocket_powerup.tscn")
var instance

var carMesh
var realMesh
var ghostMesh
var car_rocketRay
var original_Power
var animation
var steer

func _ready():
	carMesh = root_node.RealcarMesh  # Hämta carMesh från root_node
	ghostMesh = root_node.ghostMesh  # Hämta ghostMesh från root_node
	realMesh = root_node.RealcarMesh
	car_rocketRay = root_node.car_rocketRay
	animation = root_node.animation_player
	if car_rocketRay == null:
		print("car_rocketRay is not assigned!")
	original_Power = root_node.engine_force
	steer = 0.3

func change_state(newState):
	state = newState

func _physics_process(delta):
	match state:
		States.IDLE:
			idle(delta)
		States.DRIVING:
			driving(delta)
		States.DRIFTING:
			drifting(delta)
		States.POWERUP:
			powerUp()
		States.DAMAGE:
			damage()

func idle(delta):
	RFW.wheel_friction_slip = vehicle_body_3d.traction
	LFW.wheel_friction_slip = vehicle_body_3d.traction
	RBW.wheel_friction_slip = vehicle_body_3d.traction *0.8
	LBW.wheel_friction_slip = vehicle_body_3d.traction * 0.8
	
	
	if engine_sound.pitch_scale > 0.5:
		engine_sound.pitch_scale -= 1 * delta
		
	if Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_throttle"):
		#print("Driving")
		change_state(States.DRIVING)
	
	if Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_drift"):
		#print("Drifting!")
		change_state(States.DRIFTING)
		
	if Input.is_action_just_pressed("player" + str(root_node.player_index + 1) + "_action"):
		#print("POWER!")
		change_state(States.POWERUP)
		
func driving(delta):
	# Nollställ engine_force i början av varje frame
	root_node.engine_force = 0
	steer = 1
	
	if engine_sound.pitch_scale < 2:
		engine_sound.pitch_scale += 1 * delta
		
	# Hantera gas-inmatning
	if Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_throttle"):
		if ((RBW.get_rpm() < root_node.Top_Speed && (RBW.get_rpm() > -root_node.Top_Speed)) || (root_node.boostSpeed > 1)):
			root_node.engine_force = Input.get_joy_axis(root_node.player_index, 5) * root_node.Acceleration + root_node.boostSpeed
		
	# Hantera broms-inmatning
	if Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_brake"):
		print("Brake!")
		if (RBW.get_rpm() > -200):
			root_node.engine_force = (Input.get_joy_axis(root_node.player_index, 4) * root_node.Acceleration + root_node.boostSpeed) * -1
		else:
			root_node.engine_force = 50

	if not Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_throttle") and not Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_brake"):
		change_state(States.IDLE)
		
	if Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_drift"):
		print("Drifting!")
		change_state(States.DRIFTING)

	if Input.is_action_just_pressed("player" + str(root_node.player_index + 1) + "_action"):
		print("POWER!")
		change_state(States.POWERUP)

	smoke_emitt.lifetime = 1
	
func drifting(delta):
	if not Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_drift"):

		change_state(States.DRIVING)
	# Justera hjulfriktionen för att simulera sladdning
	RFW.wheel_friction_slip = vehicle_body_3d.traction * 0.7
	LFW.wheel_friction_slip = vehicle_body_3d.traction * 0.7
	RBW.wheel_friction_slip = vehicle_body_3d.traction * 0.1
	LBW.wheel_friction_slip = vehicle_body_3d.traction * 0.1
	steer = 2
	smoke_emitt.lifetime = 1

	if Input.is_action_just_pressed("player" + str(root_node.player_index + 1) + "_action"):
		print("POWER!")
		change_state(States.POWERUP)

func powerUp():
	if powerUpID.powerUpNum != 0:
		icon.set_icon_invisible()
		if powerUpID.powerUpNum == 1:
			timer.start(3)
			fire.used_fire()
			root_node.set_boost_speed(1000)
			change_state(States.IDLE)
		elif powerUpID.powerUpNum == 2:
			timer.start(5)
			root_node.set_collision_layer_value(4, 0)
			root_node.set_collision_mask_value(4,0)
			print(root_node.collision_mask)     
			carMesh.visible = false
			ghostMesh.visible = true
			change_state(States.IDLE)
		elif powerUpID.powerUpNum == 3:
			if car_rocketRay != null:
				instance = rocket_Scene.instantiate()
				get_tree().root.add_child(instance)
				instance.global_transform.origin = car_rocketRay.global_transform.origin
				instance.global_transform.basis = car_rocketRay.global_transform.basis
				change_state(States.IDLE)
		powerUpID.powerUpNum = 0
	change_state(States.IDLE)

func damage():
	change_state(States.IDLE)   

func _on_timer_timeout():
	root_node.set_collision_layer_value(4, 1)
	root_node.set_collision_mask_value(4,1)
	carMesh.visible = true
	ghostMesh.visible = false
	timer.stop()
	fire.stop_fire()
	root_node.set_boost_speed(0)
	change_state(States.IDLE)

func _on_timer_damage_timeout():
	timer_damage.stop()
	root_node.engine_force = original_Power
	damage()

func _on_damage_area_area_entered(area):
	animation.play("Damaged")
	root_node.engine_force = 0
	root_node.steering = 0
