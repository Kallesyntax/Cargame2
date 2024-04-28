extends SubViewportContainer


@onready var speed = $SubViewport/Label
@export var speedWheel = speed
var output =""

func _process(delta):
	print(speedWheel.get_rpm())
	output = "Speed: " + str(speedWheel.get_rpm())
	speed.text = output
