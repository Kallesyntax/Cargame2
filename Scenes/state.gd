class_name State

extends Node

signal transition(new_state_name: StringName)

enum States {IDLE, SlIDING, POWERUP}

var state = States.IDLE


@export var fire : Node
@export var car : VehicleBody3D

@onready var icon = $"../3d_ui"
@onready var powerUpID = $".."
@onready var carmesh = $"../CarMesh"
@onready var timer = $"../Timer"

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
	
func idle():
	#print("Idle")
	if Input.is_action_pressed("slide"):
		change_state(States.SlIDING)	
	if Input.is_action_just_pressed("action"):
		change_state(States.POWERUP)	
		
func slide():
	
	if !Input.is_action_pressed("slide"):
		change_state(States.IDLE)
		
		
func powerUp():	
	if powerUpID.powerUpNum != 0:
		icon.set_icon_invisible()
		if (powerUpID.powerUpNum == 1):
			timer.start(2)
			print("Turbo")	
			fire.used_fire()
			car.set_boost_speed(5200) 
			change_state(States.IDLE)
		if (powerUpID.powerUpNum == 2):
			timer.start(5)
			print("Ghost")	
			car.set_collision_mask_value(4,0)
			car.set_collision_mask_value(5,0)
			print(car.collision_mask)			
			carmesh.transparency = 0.1
			change_state(States.IDLE)
		powerUpID.powerUpNum = 0
	
	
func _on_timer_timeout():
	car.set_collision_mask_value(4,1)
	car.set_collision_mask_value(5,1)
	carmesh.transparency = 0	
	timer.stop()
	fire.stop_fire()
	car.set_boost_speed(000) 
	change_state(States.IDLE)
# Called when the node enters the scene tree for the first time.

