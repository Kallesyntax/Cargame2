class_name CarBaseState

extends Node

signal transition(new_state_name: StringName)

enum States {IDLE, SLIDING, POWERUP, DAMAGE}

var state = States.IDLE

@export var fire: Node
@export var root_node: VehicleBody3D

@onready var icon = $"../3d_ui"
@onready var powerUpID = $".."
@onready var timer = $"../Timer"
@onready var timer_damage = $TimerDamage

var rocket_Scene = load("res://Scenes/Powerups/Rocket_powerup.tscn")
var instance

var carMesh
var ghostMesh
var car_rocketRay
var original_Power
var animation

func _ready():
	carMesh = root_node.carMesh  # Hämta carMesh från root_node
	ghostMesh = root_node.ghostMesh  # Hämta ghostMesh från root_node
	car_rocketRay = root_node.car_rocketRay
	animation = root_node.animation_player
	if car_rocketRay == null:
		print("car_rocketRay is not assigned!")
	original_Power = root_node.engine_force

func change_state(newState):
	state = newState

func _physics_process(delta):
	match state:
		States.IDLE:
			idle()
		States.SLIDING:
			slide()
		States.POWERUP:
			powerUp()
		States.DAMAGE:
			damage()

func idle():
	if Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_slide"):
		change_state(States.SLIDING)
	if Input.is_action_just_pressed("player" + str(root_node.player_index + 1) + "_action"):
		change_state(States.POWERUP)

func slide():
	if not Input.is_action_pressed("player" + str(root_node.player_index + 1) + "_slide"):
		change_state(States.IDLE)

func powerUp():
	if powerUpID.powerUpNum != 0:
		icon.set_icon_invisible()
		if powerUpID.powerUpNum == 1:
			timer.start(3)
			fire.used_fire()
			root_node.set_boost_speed(5200)
			change_state(States.IDLE)
		elif powerUpID.powerUpNum == 2:
			timer.start(5)
			root_node.set_collision_layer_value(4, 0)
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

func damage():
	change_state(States.IDLE)
	

func _on_timer_timeout():
	root_node.set_collision_layer_value(4, 1)
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
	#timer_damage.start(3)
