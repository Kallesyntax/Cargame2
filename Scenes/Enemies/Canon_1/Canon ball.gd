extends Node3D

# Initial velocity and acceleration
const SPEED = 50


@onready var mesh_instance_3d = $MeshInstance3D


func _ready():
	pass# Set up any necessary initialization here

func _physics_process(delta):
	# Update the velocity
	position += transform.basis * Vector3(0,-SPEED, 0) * delta
