extends VehicleBody3D

# Constants for vehicle behavior
const MAX_ENGINE_FORCE = 800
const MAX_BRAKE_FORCE = 500
const MAX_STEERING_ANGLE = deg_to_rad(20)
const STEERING_SPEED = deg_to_rad(120)

# Nodes for interest and danger detection
@onready var navigation_agent = $NavigationAgent3D
@export var navigation_region: NavigationRegion3D

# Variables for dynamic behavior
var current_steering_angle = 0.0
var max_distance = 40

var checkpoints = []
var current_checkpoint_index = 1
var path = []

func _ready():
	engine_force = MAX_ENGINE_FORCE
	brake = 0
	steering = 0
	
	# Assuming the NavigationRegion3D is a direct child of the root node
		# Get the navigation map RID directly from the NavigationRegion3D
	var navigation_map_rid = navigation_region
	
	var checkpoint_node = get_node("../Checkpoints")
	for i in range(checkpoint_node.get_child_count()):
		var name = str(i + 1)  # Checkpoints named as '1', '2', '3', etc.
		checkpoints.append(checkpoint_node.get_node(name).global_transform.origin)
	
	# Initialize the navigation path
	path = NavigationServer3D.map_get_path(navigation_map_rid, global_transform.origin, checkpoints[current_checkpoint_index], true)

func _physics_process(delta):
	var brake_force = 0.0
	# Get the navigation map RID directly from the NavigationRegion3D
	var navigation_region = get_node(".../NavigationRegion3D")
	var navigation_map_rid = navigation_region.navmesh_id
	path = NavigationServer3D.map_get_path(navigation_map_rid, global_transform.origin, checkpoints[current_checkpoint_index], true)
	# Handle obstacle avoidance
	if $Dangers/D_Front.is_colliding():
		brake_force = MAX_BRAKE_FORCE
		# Recalculate the path to avoid the obstacle
		path = NavigationServer3D.map_get_path(navigation_map_rid, global_transform.origin, checkpoints[current_checkpoint_index], true)
	
	# Follow the path
	if path.size() > 1:
		var direction_to_checkpoint = (path[1] - global_transform.origin).normalized()
		var forward_direction = -global_transform.basis.z.normalized()
		var steering_direction = forward_direction.cross(direction_to_checkpoint).y
		
		# Adjust steering based on the direction to the next point in the path
		if steering_direction > 0:
			current_steering_angle = min(MAX_STEERING_ANGLE, current_steering_angle + STEERING_SPEED * delta)
		elif steering_direction < 0:
			current_steering_angle = max(-MAX_STEERING_ANGLE, current_steering_angle - STEERING_SPEED * delta)
		
		# Update the vehicle's steering
		steering = current_steering_angle
		
		# Move to the next checkpoint if close enough to the current target
		if global_transform.origin.distance_to(path[1]) < 5.0:
			path.remove(0)  # Remove the reached point from the path
			if path.size() == 1:  # Check if the last point in the path is reached
				current_checkpoint_index += 1
				if current_checkpoint_index < checkpoints.size():
					# Calculate a new path to the next checkpoint
					path = NavigationServer3D.map_get_path(navigation_map_rid, global_transform.origin, checkpoints[current_checkpoint_index], true)
				else:
					# Reset to the first checkpoint if all have been reached
					current_checkpoint_index = 0
	
	# Apply forces
	brake = brake_force
	engine_force = MAX_ENGINE_FORCE - abs(current_steering_angle) * MAX_ENGINE_FORCE / MAX_STEERING_ANGLE - brake_force
