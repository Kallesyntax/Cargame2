extends CarState

func enter_state() -> void:
	print("Connected joypads:", Input.get_connected_joypads())
	if is_instance_valid(car):
		car.RFW.wheel_friction_slip = car.traction
		car.LFW.wheel_friction_slip = car.traction
		car.RBW.wheel_friction_slip = car.traction * 0.8
		car.LBW.wheel_friction_slip = car.traction * 0.8

func physics_update(delta: float) -> void:
	if not is_instance_valid(car):
		return

	# Använd CarState:s hjälpmetoder för att läsa korrekt pad + axis
	var throttle: float = read_throttle_value()
	var brake: float = read_brake_value()

	if abs(throttle) > car.DEADZONE or abs(brake) > car.DEADZONE:
		if state_machine != null:
			state_machine.switch_to_state("DrivingState")
		return

	# Idle-fysik
	car.engine_force = 0
	car.brake = true

	# Gemensamma hanterare från basklass
	handle_steering(delta)
	handle_powerup_input()
