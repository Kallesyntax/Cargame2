class_name State

extends Node

signal transition(new_state_name: StringName)

enum States {IDLE, SlIDING, POWERUP, DAMAGE}

var state = States.IDLE


@export var fire : Node
@export var root_node : VehicleBody3D
@export var animation_player : AnimationPlayer

@onready var original_Power = root_node.engine_force
@onready var ghost_mesh = $"../GhostMesh"
@onready var icon = $"../3d_ui"
@onready var powerUpID = $".."
@onready var carmesh = $"../CarMesh"
@onready var timer = $"../Timer"
@onready var timer_damage = $"../TimerDamage"
@onready var car_rocketRay = $"../car_rocketRay"

func change_state(newState):
	state= newState
	
func _physics_process(delta):
	match state:
		States.IDLE:
			idle()
		States.SlIDING:
			slide()
		States.POWERUP:
			powerUp()
		States.DAMAGE:
			damage()
	
func idle():
	#print("Idle")
	if Input.is_action_pressed("slide"):
		change_state(States.SlIDING)	
	if Input.is_action_just_pressed("action"):
		change_state(States.POWERUP)	
		
func slide():	
	if !Input.is_action_pressed("slide"):
		print("Tja Slide")
		change_state(States.IDLE)
				
func powerUp():	
	if powerUpID.powerUpNum != 0:
		icon.set_icon_invisible()
		if (powerUpID.powerUpNum == 1):
			timer.start(3)
			print("Turbo")	
			fire.used_fire()
			root_node.set_boost_speed(5200) 
			change_state(States.IDLE)
		if (powerUpID.powerUpNum == 2):
			timer.start(5)
			print("Ghost")	
			root_node.set_collision_layer_value(4,0)
			print(root_node.collision_mask)			
			carmesh.visible = 0
			ghost_mesh.visible = 1
			change_state(States.IDLE)
		if (powerUpID.powerUpNum == 3):
			print("Rocket")	
			change_state(States.IDLE)
			root_node.fire_Rocket(car_rocketRay)
		powerUpID.powerUpNum = 0

func damage():	
	print("Damage state")
	change_state(States.IDLE)
	
func _on_timer_timeout():
	root_node.set_collision_layer_value(4,1)	
	carmesh.visible = 1
	ghost_mesh.visible = 0		
	timer.stop()
	fire.stop_fire()
	root_node.set_boost_speed(000) 
	change_state(States.IDLE)
# Called when the node enters the scene tree for the first time.

func _on_timer_damage_timeout():
	timer_damage.stop()
	root_node.engine_force = original_Power
	damage()
	


func _on_damage_area_area_entered(area):
	animation_player.play("Damaged")
	root_node.engine_force = 0
	root_node.steering = 0	
	timer_damage.start(3)
	
	
