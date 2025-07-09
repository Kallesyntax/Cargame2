extends CarState

func enter_state():

	car.RFW.wheel_friction_slip = car.traction
	car.LFW.wheel_friction_slip = car.traction
	car.RBW.wheel_friction_slip = car.traction * 0.8
	car.LBW.wheel_friction_slip = car.traction * 0.8

func physics_update(delta: float) -> void:
	if car.is_damaged == true:
		state_machine.switch_to_state("DamageState")	
		
	var throttle = Input.get_joy_axis(car.player_index, 5)  # Antag gaspedal axis
	var brake = Input.get_joy_axis(car.player_index, 2)     # Antag broms axi
	if abs(throttle) > car.DEADZONE or abs(brake) > car.DEADZONE:
		state_machine.switch_to_state("DrivingState")	

	car.engine_force = 0
	car.brake = true
	
	super.handle_steering(delta)
	super.handle_powerup_input()
