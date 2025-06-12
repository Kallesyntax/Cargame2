extends CarState

func enter_state():
	car.RFW.wheel_friction_slip = car.traction
	car.LFW.wheel_friction_slip = car.traction
	car.RBW.wheel_friction_slip = car.traction * 0.8
	car.LBW.wheel_friction_slip = car.traction * 0.8

func physics_update(delta: float):
	if car.engine_sound.pitch_scale > 0.5:
		car.engine_sound.pitch_scale -= 1 * delta
	
	var p = str(car.player_index + 1)
	
	if Input.is_action_pressed("player%s_throttle" % p):
		state_machine.switch_to_state("DrivingState")
	elif Input.is_action_pressed("player%s_drift" % p):
		state_machine.switch_to_state("DriftingState")
	elif Input.is_action_just_pressed("player%s_action" % p):
		state_machine.switch_to_state("PowerupState")
