extends Node3D

# Initial velocity and acceleration
const SPEED = 10


@onready var mesh_instance_3d = $MeshInstance3D


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
