extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var checkpoints = $"../../../Checkpoints"
var active_checkpoint = 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slide"):
		get_to_target()
		
func get_to_target():
	print("Active checkpoint ", active_checkpoint)
	var next_position := Vector3.ZERO
	next_position = checkpoints.get_child(active_checkpoint).transform.origin
	print(next_position)
	navigation_agent_3d.set_target_position(next_position)
	if active_checkpoint <= checkpoints.get_child_count():		
		active_checkpoint = (active_checkpoint + 1) % checkpoints.get_child_count()
	else:
		active_checkpoint = 0		
func _physics_process(delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()		
	velocity = direction * 10.0
	move_and_slide()




func _on_navigation_agent_3d_navigation_finished():
	print("Done!!")
	get_to_target()
	
