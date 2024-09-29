extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3 = Vector3(-10.0, 0.0, 10.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var navigation_region_3d =  $"../../NavigationRegion3D" # Adjust the path to your NavigationRegion3D node

func _ready():
	# These values need to be adjusted for the actor's speed and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_random_movement_target()

func set_random_movement_target():
	var random_pos = get_random_pos_in_sphere(50)  # Adjust the sphere radius as needed
	set_movement_target(random_pos)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		set_random_movement_target()

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()  # The second argument specifies the floor normal (usually up)

func get_random_pos_in_sphere(radius: float) -> Vector3:
	var x1 = randi_range(-1, 1)
	var x2 = randi_range(-1, 1)

	while x1 * x1 + x2 * x2 >= 1:
		x1 = randi_range(-1, 1)
		x2 = randi_range(-1, 1)

	var random_pos_on_unit_sphere = Vector3(
		1 - 2 * (x1 * x1 + x2 * x2),
		0,
		1 - 2 * (x1 * x1 + x2 * x2)
	)

	random_pos_on_unit_sphere.x *= randi_range(-radius, radius)
	random_pos_on_unit_sphere.z *= randi_range(-radius, radius)
	return random_pos_on_unit_sphere
