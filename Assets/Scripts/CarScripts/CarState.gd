extends Node
class_name CarState

var car: VehicleBody3D          # sätts av CarStateMachine innan enter_state()
var state_machine: CarStateMachine
var time_in_state: float = 0.0

func enter_state() -> void:
	time_in_state = 0.0
	# car är giltig här – debug om du vill:
	# print("🚗 CarState entered for player", car.player_index + 1)

func exit_state() -> void:
	pass

func physics_update(delta: float) -> void:
	time_in_state += delta
	handle_steering(delta)
	# override i DrivingState kallar handle_throttle
	# override i alla states kan även anropa handle_powerup_input()

# Ordinal mapping: spelare N läser joypad pads[N]
func _get_device_for_player() -> int:
	var dev: int = car.device_id
	if dev < 0:
		var pads = Input.get_connected_joypads()
		if pads.size() > 0:
			dev = pads[0]
	return dev
	

# -------- Steering --------
func read_steer_axis() -> float:
	var v: float = 0.0
	var dev: int = _get_device_for_player()
	if dev >= 0:
		v = Input.get_joy_axis(dev, 0)
	if abs(v) <= car.DEADZONE:
		var left  = "player%d_left"  % (car.player_index + 1)
		var right = "player%d_right" % (car.player_index + 1)
		if Input.is_action_pressed(left):
			v = -1.0
		elif Input.is_action_pressed(right):
			v =  1.0
		else:
			v =  0.0
	return v

func handle_steering(delta: float) -> void:
	if not is_instance_valid(car):
		return
	var steer_input: float = read_steer_axis()
	if abs(steer_input) < car.DEADZONE:
		steer_input = 0.0
	car.steering_input = move_toward(
		car.steering_input,
		steer_input * -1.0 * car.MAX_STEER,
		delta * 2.5
	)

# -------- Throttle / Brake helpers --------
func read_throttle_value() -> float:
	var val: float = 0.0
	var dev: int = _get_device_for_player()
	if dev >= 0:
		var v: float = Input.get_joy_axis(dev, 5)
		if v > car.DEADZONE:
			val = v
	if val <= car.DEADZONE:
		val = Input.get_action_strength("player%d_throttle" % (car.player_index + 1))
	return val

func read_brake_value() -> float:
	var val: float = 0.0
	var dev: int = _get_device_for_player()
	if dev >= 0:
		var v: float = Input.get_joy_axis(dev, 4)
		if v > car.DEADZONE:
			val = v
	if val <= car.DEADZONE:
		val = Input.get_action_strength("player%d_brake" % (car.player_index + 1))
	return val

func handle_throttle(delta: float) -> void:
	if not is_instance_valid(car):
		return
	var throttle: float = read_throttle_value()
	var brake:    float = read_brake_value()

	if throttle <= car.DEADZONE and brake <= car.DEADZONE:
		if state_machine != null:
			state_machine.switch_to_state("IdleState")
		return

	var engine_power: float = 0.0
	if brake > car.DEADZONE and throttle <= car.DEADZONE:
		car.brake = 1000
	elif throttle > car.DEADZONE:
		car.brake = 0
		engine_power = throttle * car.Acceleration + car.boostSpeed
	else:
		car.brake = 0

	car.engine_force = engine_power

# -------- Powerups --------
func handle_powerup_input() -> void:
	if not is_instance_valid(car):
		return
	var act = "player%d_action" % (car.player_index + 1)
	if Input.is_action_just_pressed(act) and car.powerUpNum > 0:
		activate_powerup(car.powerUpNum)

func activate_powerup(num: int) -> void:
	match num:
		1:
			car.boostSpeed += 1200.0
			await get_tree().create_timer(2.0).timeout
			car.boostSpeed = max(car.boostSpeed - 1200.0, 0.0)
			print("🔥 Boost ended")
		2:
			if car.has_node("Ghost_Timer"):
				car.get_node("Ghost_Timer").start(5.0)
			car.set_collision_layer_value(4, 0)
			car.set_collision_mask_value(4, 0)
			print("👻 Ghost on")
		3:
			if car.rocket_Scene and car.has_node("car_rocketRay"):
				var r = car.rocket_Scene.instantiate()
				get_tree().root.add_child(r)
				r.global_transform = car.get_node("car_rocketRay").global_transform
				print("🚀 Rocket fired")
		_:
			print("⚠️ Unknown powerup:", num)
	car.powerUpNum = -1
