extends Node3D

@onready var noise = $FireAudio
@export var distance = 0
	
func used_fire():	
	noise.play()
	visible = 1	

func stop_fire():
	noise.stop()
	visible = 0


