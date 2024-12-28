extends SubViewportContainer

@onready var lap = $SubViewport/HBoxContainer/Lap
@onready var speed = $SubViewport/HBoxContainer/Speed
@export var speedWheel = speed
var speedOutput =""
var this_lap =""

func _process(delta):
	speedOutput = "Speed: " + str("%3.0f" % speedWheel.get_rpm())
	speed.text = speedOutput

