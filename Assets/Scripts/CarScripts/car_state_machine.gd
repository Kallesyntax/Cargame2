extends Node

var current_state: CarState = null

@export var start_state_path: NodePath  # Ex. "IdleState"
@onready var car: Node = get_parent()

func _ready():
	# Hitta och aktivera start state
	if has_node(start_state_path):
		var start_state = get_node(start_state_path)
		switch_to_state(start_state.name)

func _physics_process(delta):
	if current_state and current_state.has_method("physics_update"):
		current_state.physics_update(delta)

func switch_to_state(state_name: String) -> void:
	var next_state = get_node(state_name)
	if next_state == null:
		push_warning("State not found: " + state_name)
		return
	
	if current_state:
		current_state.exit_state()
	
	current_state = next_state as CarState
	current_state.car = car
	current_state.state_machine = self
	current_state.enter_state()
