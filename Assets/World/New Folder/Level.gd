# Level.gd
extends Node3D
@onready var playercount = Global.selected_player_count

func _ready():

	# Load the selected car scene
	var car_scene = load(Global.selected_car1_scene)
	# Ensure car_scene is not null and is indeed a PackedScene
	if car_scene and car_scene is PackedScene:
		var car_instance = car_scene.instantiate()
		# Set the spawn position of the car
		var spawn_position = Vector3(250, -0.5, 30) # Replace with desired position
		# Set the rotation of the car (example: 90 degrees around the Y axis)
		var rotation_degrees = Vector3(0, -90, 0) # Replace with desired rotation in degrees
		var rotation_radians = rotation_degrees * PI / 180.0 # Convert degrees to radians
		var rotated_basis = Basis().rotated(Vector3.UP, rotation_radians.y)
		car_instance.transform = Transform3D(rotated_basis, spawn_position)
		# Add the car instance to the level
		add_child(car_instance)
		
	else:
		print("Error: Unable to load the car scene.")
