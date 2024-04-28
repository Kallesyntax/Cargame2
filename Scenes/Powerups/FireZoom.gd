extends Node3D

@onready var noise = $FireAudio
@export var distance = 0
	
func used_fire():	
	noise.play()
	print("pp")
	visible = 1	

func stop_fire():
	print("uu")
	noise.stop()
	visible = 0


