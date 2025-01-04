extends Node3D
@onready var timer = $RigidBody3D/Timer
# Initial velocity and acceleration
const SPEED = 35
@onready var area = $Area3D
@onready var ff_timer = $FFTimer

func _ready():
	area.set_collision_layer_value(8,0)
	area.set_collision_mask_value(8,0)
	ff_timer.start()
	var timer = Timer.new()
	timer.wait_time = 6.0  # Set this to how many seconds you want the cannonball to last
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
	queue_free()  # This will remove the cannonball from the scene

func _physics_process(delta):
	# Update the velocity
	position += transform.basis * Vector3(0,-SPEED, 00) * delta

func _on_area_3d_area_entered(body):
	print(body.name)
func _on_ff_timer_timeout():
	area.set_collision_layer_value(8,1)
	area.set_collision_mask_value(8,1)
