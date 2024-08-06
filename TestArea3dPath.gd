extends Area3D

# Reference to the PathFollow3D node
var path_follower: PathFollow3D

func _ready():
	path_follower = get_node("PathFollow3D")

func _process(delta):
	# Move the PathFollow3D along the path
	#path_follower.offset += delta * speed # 'speed' is the rate at which the Area3D moves along the path

	# Check for the car within the Area3D
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Car": # Replace "Car" with the actual name of your car node
			pass# Adjust car behavior to follow the Area3D
