extends Area3D


@onready var timer = $Timer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	disable_mode =1
	visible = 0
	timer.start()
	pass # Replace with function body.


func _on_timer_timeout():
	timer.stop()
	visible =1
	disable_mode = 0
