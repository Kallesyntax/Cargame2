extends Control

@onready var lap = $CanvasLayer/SpeedPanel/MarginContainer/HBoxContainer/Lap
@onready var speed = $CanvasLayer/SpeedPanel/MarginContainer/HBoxContainer/Speed

@onready var turbo = $CanvasLayer/PowerupPanel/MarginContainer/Turbo
@onready var ghost = $CanvasLayer/PowerupPanel/MarginContainer/Ghost
@onready var rocket = $CanvasLayer/PowerupPanel/MarginContainer/Rocket


@onready var vehicle_body_3d = $".."
@export var speedWheel = speed



var speedOutput =""
var this_lap =""

func _process(delta):
	speedOutput = "Speed: " + str("%3.0f" % speedWheel.get_rpm())
	this_lap = "Lap: " + str(vehicle_body_3d.active_lap)
	
	speed.text = speedOutput
	lap.text = this_lap

func set_icon_visible(powerUpNum):
	if(powerUpNum == 1):
		turbo.visible = true
	if(powerUpNum== 2):
		ghost.visible = true
	if(powerUpNum== 3):
		rocket.visible = true
		
func set_icon_invisible():
	turbo.visible = false
	ghost.visible = false
	rocket.visible = false
