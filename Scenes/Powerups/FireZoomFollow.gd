# This script should be attached to the node that you want to follow the car.
extends Node3D

# Reference to the car node
var car_node: Node3D
# The desired offset from the car node
var offset = Vector3(-160, -40, 0) # Adjust the offset as needed

func _ready():
	# Initialize the car_node with the correct reference
	car_node = get_node("/root/Main/Fire_car") # Adjust the path as necessary

func _process(delta):
	# Calculate the desired position with the offset
	var desired_position = car_node.global_transform.origin + offset
	
	
	# Update this node's position to move towards the desired position
	global_transform.origin = global_transform.origin.move_toward(desired_position, 1) # Adjust the speed as needed
	
