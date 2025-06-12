extends CarState

func enter_state():
	car.RFW.wheel_friction_slip = car.traction * 0.7
	car.LFW.wheel_friction_slip = car.traction * 0.7
	car.RBW.wheel_friction_slip = car.traction * 0.5
	car.LBW.wheel_friction_slip = car.traction * 0.5

func physics_update(delta: float):
	var p = str(car.player_index + 1)

	if not Input.is_action_pressed("player%s_drift" % p):
		state_machine.switch_to_state("DrivingState")

	if Input.is_action_just_pressed("player%s_action" % p):
		state_machine.switch_to_state("PowerupState")
