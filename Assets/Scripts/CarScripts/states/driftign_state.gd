extends CarState
class_name DriftingState

var original_steer = 0.3
var original_friction = {}

func enter_state():
	print("Entered DriftingState")

	# Spara original styrvärde
	original_steer = car.MAX_STEER
	car.MAX_STEER = 0.6

	# Spara original friktion och applicera olika värden
	original_friction[car.LFW] = car.LFW.wheel_friction_slip
	original_friction[car.RFW] = car.RFW.wheel_friction_slip
	original_friction[car.LBW] = car.LBW.wheel_friction_slip
	original_friction[car.RBW] = car.RBW.wheel_friction_slip

	car.LFW.wheel_friction_slip *= 1
	car.RFW.wheel_friction_slip *= 1
	car.LBW.wheel_friction_slip *= 0.8
	car.RBW.wheel_friction_slip *= 0.8

func exit_state():
	car.MAX_STEER = original_steer

	# Återställ friktion
	for wheel in original_friction.keys():
		wheel.wheel_friction_slip = original_friction[wheel]

func physics_update(delta):
	var drift_action = Input.is_action_pressed("player%d_drift" % (car.player_index + 1))
	if not drift_action:
		state_machine.switch_to_state("DrivingState")
		return

	super.handle_steering(delta)
	super.handle_throttle(delta)
	super.handle_powerup_input()
