extends Area3D

#@onready var timer = $Timer
@export var checkpointID = 0
var active_checkpoint = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_checkpointer():
	active_checkpoint +=1
	print("Checkpoint: ") 
	print(active_checkpoint)
	return checkpointID

func _on_area_entered(area):	
	update_checkpointer()
	disable_mode =1
	visible = 0
	#timer.start()
	pass # Replace with function body.

func _on_timer_timeout():
	#timer.stop()
	visible =1
	disable_mode = 0
