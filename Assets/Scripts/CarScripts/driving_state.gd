extends CarState
class_name DrivingState


# kort grace-period (sekunder) efter state-enter innan auto-switch-to-idle tillåts
const GRACE_SECONDS: float = 0.12

func enter_state() -> void:
	time_in_state = 0.0
	print("🚗 Entered DrivingState")

func physics_update(delta: float) -> void:
	time_in_state += delta
	if not is_instance_valid(car):
		return

	# snabb drift-switch
	var drift_action = Input.is_action_pressed("player%d_drift" % (car.player_index + 1))
	if drift_action:
		if state_machine != null:
			state_machine.switch_to_state("DriftingState")
		return

	# styrning och powerups alltid
	handle_steering(delta)
	handle_powerup_input()

	# läs throttle/brake tidigt för debug och beslut
	var device = _get_device_for_player()
	var t = read_throttle_value()
	var b = read_brake_value()
	var rbw_rpm = "nil"
	if is_instance_valid(car.RBW):
		rbw_rpm = str(car.RBW.get_rpm())
	# Kör throttle-logik (CarState.handle_throttle hanterar switch till Idle om nödvändigt)
	handle_throttle(delta)
