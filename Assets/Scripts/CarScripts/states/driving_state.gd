extends CarState
class_name DrivingState

func enter_state():
	print("🚗 Entered DrivingState")	

func physics_update(delta):
	if car.is_damaged == true:
		state_machine.switch_to_state("DamageState")	
	
	var drift_action = Input.is_action_pressed("player%d_drift" % (car.player_index + 1))
	if drift_action:
		state_machine.switch_to_state("DriftingState")
		return

	super.handle_steering(delta)
	super.handle_throttle(delta)
	super.handle_powerup_input()
