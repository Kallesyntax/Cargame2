extends Control

@onready var lap = $CanvasLayer/SpeedPanel/MarginContainer/HBoxContainer/Lap
@onready var speed = $CanvasLayer/SpeedPanel/MarginContainer/HBoxContainer/Speed

@onready var current_Laptime = $CanvasLayer/LapTimer/MarginContainer/VBoxContainer/Current
@onready var best_Laptime = $CanvasLayer/LapTimer/MarginContainer/VBoxContainer/Best
@onready var total_Laptime = $CanvasLayer/LapTimer/MarginContainer/VBoxContainer/Total

@onready var turbo = $CanvasLayer/PowerupPanel/MarginContainer/Turbo
@onready var ghost = $CanvasLayer/PowerupPanel/MarginContainer/Ghost
@onready var rocket = $CanvasLayer/PowerupPanel/MarginContainer/Rocket
@onready var vehicle_body_3d := get_parent() as BaseCarScript

@export var speedWheel = speed
@export var lap_timer: LapTimer

var speedOutput =""
var this_lap =""
var current_lap=""
var best_lap=""
var total_lap=""

func _process(delta):
	speedOutput = "Speed: " + str("%3.0f" % speedWheel.get_rpm())
	this_lap = "Lap: " + str(vehicle_body_3d.active_lap +1)
	current_lap = "Current lap: " + str(format_time(vehicle_body_3d.lap_timer.get_current_lap_time()))
	
	var best_time = vehicle_body_3d.lap_timer.get_best_lap_time()
	if best_time > 0:
		best_lap = "Best lap: " + str(format_time(best_time))
	else:
		best_lap = "Best lap: --.--"

	total_lap = "Total time: " + str(format_time(vehicle_body_3d.lap_timer.total_time +vehicle_body_3d.lap_timer.get_current_lap_time()))

	# Sätt texter
	speed.text = speedOutput
	lap.text = this_lap
	current_Laptime.text = current_lap
	best_Laptime.text = best_lap
	total_Laptime.text = total_lap

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = seconds - (mins * 60)
	return "%d:%05.2f" % [mins, secs]
	
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
