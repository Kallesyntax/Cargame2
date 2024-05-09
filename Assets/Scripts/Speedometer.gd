extends SubViewportContainer


@onready var speed = $SubViewport/Label
@export var speedWheel = speed
var output =""

func _process(delta):
	print("%3.0f" % speedWheel.get_rpm())
	output = "Speed: " + str("%3.0f" % speedWheel.get_rpm())
	speed.text = output
