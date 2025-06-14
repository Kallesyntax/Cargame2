extends Node
class_name CarStateMachine

var current_state: CarState = null

@onready var car: BaseCarScript = get_parent() as BaseCarScript

@export var start_state_path: NodePath  # Exempel: "IdleState"




func _ready():
	if has_node(start_state_path):
		var start_state = get_node(start_state_path)
		switch_to_state(start_state.name)

func _physics_process(delta):
	if current_state:
		if current_state.has_method("physics_update"):
			current_state.physics_update(delta)	

func switch_to_state(state_name: String) -> void:
	var next_state = get_node(state_name)
	if next_state == null:
		push_warning("⚠️ State not found: " + state_name)
		return

	if current_state:
		current_state.exit_state()

	current_state = next_state as CarState
	current_state.car = car  # Viktigt! Ska peka på BaseCarScript
	current_state.state_machine = self
	print("🔄 Switching to state:", state_name)
	current_state.enter_state()

func setup_car(car_instance):
	car = car_instance
