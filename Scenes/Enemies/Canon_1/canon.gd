extends Node3D

# Preload the cannonball scene
var cannonball_scene = load("res://Scenes/Enemies/Canon_1/Canon ball.tscn")
var fire_interval = 8.0
var instance

@onready var timer = $Timer
@onready var Canon_ray = $CanonCanon/RayCast3D

# Ready function to start the process
func _ready():
	pass # Set up any necessary initialization here

func _process(_delta):
	pass

func fire_cannonball():
	# Debugging: Print the state of the FirePoint node
	instance = cannonball_scene.instantiate()
	instance.position = Canon_ray.global_position
	instance.transform.basis = Canon_ray.global_transform.basis
	get_parent().add_child(instance)
	# Rest of the firing logic...
