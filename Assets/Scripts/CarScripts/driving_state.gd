extends CarState

func enter_state():
	car.engine_force = 0

func physics_update(delta: float):
	var p = str(car.player_index + 1)

	if car.engine_sound.pitch_scale < 2:
		car.engine_sound.pitch_scale += 1 * delta

	if Input.is_action_pressed("player%s_throttle" % p):
		if (car.RBW.get_rpm() < car.Top_Speed and car.RBW.get_rpm() > -car.Top_Speed) or (car.boostSpeed > 1):
			var axis_val = Input.get_joy_axis(car.player_index, 5)
			car.engine_force = axis_val * car.Acceleration + car.boostSpeed

	if Input.is_action_pressed("player%s_brake" % p):
		if car.RBW.get_rpm() > -200:
			var brake_val = Input.get_joy_axis(car.player_index, 4)
			car.engine_force = (brake_val * car.Acceleration + car.boostSpeed) * -1
		else:
			car.engine_force = 50

	if not Input.is_action_pressed("player%s_throttle" % p) and not Input.is_action_pressed("player%s_brake" % p):
		state_machine.switch_to_state("IdleState")

	if Input.is_action_pressed("player%s_drift" % p):
		state_machine.switch_to_state("DriftingState")
	elif Input.is_action_just_pressed("player%s_action" % p):
		state_machine.switch_to_state("PowerupState")
