extends Node3D
@onready var timer = $RigidBody3D/Timer
# Initial velocity and acceleration
const SPEED = 30

func _ready():
	var timer = Timer.new()
	timer.wait_time = 5.0  # Set this to how many seconds you want the cannonball to last
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
	queue_free()  # This will remove the cannonball from the scene

func _physics_process(delta):
	# Update the velocity
	position += transform.basis * Vector3(0,-SPEED, 00) * delta
