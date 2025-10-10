extends Area3D
@onready var timer = $Timer

func _ready():
	connect("body_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	pass

func _on_area_entered(area):
	if area.get_parent() is VehicleBody3D:
		disable_mode = 1
		visible = false
		timer.start()

func _on_timer_timeout():
	timer.stop()
	visible = true
	disable_mode = 0
