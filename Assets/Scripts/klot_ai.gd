extends RigidBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@export var speed: float = 30.0
@export var rotation_speed: float = 3.0
const REACH_TOLERANCE: float = 3.0

var checkpoint_manager: CheckpointManager

func _ready():
	print("🟢 AI READY: Startar bil med NavigationAgent3D...")
	
	if navigation_agent == null:
		push_error("❌ NavigationAgent3D saknas!")
		return

	var cp_node = find_checkpoints_node(get_tree().get_current_scene())
	if cp_node:
		print("✅ Hittade Checkpoints-nod:", cp_node.name)
		checkpoint_manager = CheckpointManager.new()
		checkpoint_manager.setup_from_node(cp_node)
		print("✅ Checkpoints laddade:", checkpoint_manager.checkpoints.size())

		var start_target = checkpoint_manager.get_current_checkpoint()
		print("🎯 Första checkpoint-position:", start_target)
		navigation_agent.set_target_position(start_target)
	else:
		print("❌ Kunde inte hitta en Checkpoints-nod.")

func _physics_process(delta: float):
	if checkpoint_manager == null or navigation_agent == null:
		return

	var next_point = navigation_agent.get_next_path_position()

	if next_point == Vector3.ZERO:
		print("⚠️ Inget nästa mål hittat – har pathfinding misslyckats?")
		return

	var dist = global_transform.origin.distance_to(next_point)
	#print("📍 Nästa punkt:", next_point, " | Avstånd:", dist)

	if dist < REACH_TOLERANCE:
		checkpoint_manager.go_to_next()
		var new_target = checkpoint_manager.get_current_checkpoint()
		print("➡️ Nästa checkpoint satt:", new_target)
		navigation_agent.set_target_position(new_target)
	else:
		move_towards_target(next_point, delta)

func move_towards_target(next_point: Vector3, delta: float):
	var direction = (next_point - global_transform.origin).normalized()
	var desired_rot = Basis.looking_at(direction, Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(desired_rot, rotation_speed * delta)

	var forward = -global_transform.basis.z
	var force = forward * speed
	#print("🚗 Applicerar kraft:", force)
	apply_central_force(force)

func find_checkpoints_node(node: Node) -> Node:
	if node.name == "Checkpoints":
		return node
	for child in node.get_children():
		var found = find_checkpoints_node(child)
		if found != null:
			return found
	return null
