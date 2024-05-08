extends Node3D

# Preload the cannonball scene
var cannonball_scene = preload("res://Scenes/Enemies/Canon_1/Canon ball.tscn")
@onready var timer = $Timer

# Set the interval time in seconds
var fire_interval = 2.0

# Ready function to start the process
func _ready():
	pass
# Function to fire the cannonball
func fire_cannonball():
	var cannonball_instance = cannonball_scene.instance()
	# Set the position and initial velocity of the cannonball
	# Assuming 'cannon' is the node where the cannonball will be fired from
	cannonball_instance.global_transform = $cannon.global_transform
	cannonball_instance.linear_velocity = $cannon.global_transform.basis.z.normalized() * -1000
	get_tree().root.add_child(cannonball_instance)



