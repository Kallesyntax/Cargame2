extends VehicleBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var checkpoints = $"../../../Checkpoints"
@onready var timer = $Timer
@onready var isDone = true 

var active_checkpoint = 0

func _ready():
	if navigation_agent_3d == null:
		print("NavigationAgent3D is not found!")
	else:
		print("NavigationAgent3D initialized successfully.")
	if checkpoints == null:
		print("Checkpoints node not found!")
	else:
		print("Checkpoints node initialized successfully.")
	set_next_target()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slide"):
		set_next_target()



func set_next_target():
	#print("Active checkpoint ", active_checkpoint)
	var active_checkpoint_node = checkpoints.get_child(active_checkpoint)
	#print("Active checkpoint name: ", active_checkpoint_node.name)
	var global_position = active_checkpoint_node.to_global(Vector3())
	#print("Next position: ", global_position)
	navigation_agent_3d.set_target_position(global_position)

func _physics_process(delta: float) -> void:
	if navigation_agent_3d == null:
		print("NavigationAgent3D is null in _physics_process!")
		return	
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	steer_towards(direction)
	set_next_target()
	engine_force = 200  # Adjust this value as needed

func steer_towards(direction: Vector3):
	var forward = global_transform.basis.z
	var cross = forward.cross(direction)
	steering = clamp(cross.y, -1, 1)  # Gradual steering adjustment

func _on_navigation_agent_3d_navigation_finished():
	if isDone:
		print("Done!!")
		if active_checkpoint < checkpoints.get_child_count() - 1:
			active_checkpoint += 1
		else:
			active_checkpoint = 0
		set_next_target()
		print("Next position: ", global_position)
		isDone = false
		timer.start()

func _on_timer_timeout():
	print("Timer Done")
	isDone = true
	pass # Replace with function body.
