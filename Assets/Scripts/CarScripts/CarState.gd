extends Node

class_name CarState

var car: VehicleBody3D  # Vi sätter detta explicit från state_machine
var state_machine: CarStateMachine

var topSPeed =0

func enter_state():
	pass

func exit_state():
	pass

func physics_update(delta: float) -> void:
	handle_steering(delta)

func handle_steering(delta: float) -> void:
	var steer_input := Input.get_joy_axis(car.player_index, 0)
	if abs(steer_input) < car.DEADZONE:
		steer_input = 0
	car.steering_input = move_toward(
		car.steering_input,
		steer_input * -1 * (car.MAX_STEER),
		delta * 2.5
	)

func handle_throttle(delta: float) -> void:
	var velocity = car.linear_velocity.length()
	var maxspeed = car.MAX_TOPSPEED
	var throttle = Input.get_joy_axis(car.player_index, 5)
	var brake = Input.get_joy_axis(car.player_index, 4)
	
	if abs(throttle) <= car.DEADZONE and abs(brake) <= car.DEADZONE:
		state_machine.switch_to_state("IdleState")

	var engine_power = 0.0
	if throttle > car.DEADZONE and brake < car.DEADZONE:
		print("Velocity: ",velocity," MaxSpeed: ", maxspeed, "Car multiplier ", car.MAX_TOPSPEED  )
		if velocity < maxspeed:
			engine_power = throttle * car.Acceleration + car.boostSpeed
		else:
			engine_power = 0  # Ingen extra kraft om maxhastighet uppnådd
		car.brake = 0

	elif brake > car.DEADZONE and throttle > car.DEADZONE:
		engine_power = -500
		throttle = 0

	elif brake > car.DEADZONE:
		engine_power = 0
		car.brake = 1000

	else:
		engine_power = 0
		car.brake = 0

	car.engine_force = engine_power
	
func handle_powerup_input():
	var input_action = "player%d_action" % (car.player_index + 1)
	if Input.is_action_just_pressed(input_action) and car.powerUpNum > 0:
		activate_powerup(car.powerUpNum)
			
func activate_powerup(num: int):
	if num == 1:
		# BOOST
		car.ghost_timer.start(3)
		car.firenode.used_fire()
		car.boostSpeed =1000
		print("🔥 BOOST activated")

	elif num == 2:
		# GHOST MODE / INVINCIBLE
		car.ghost_timer.start(5)
		car.set_collision_layer_value(4, 0)
		car.set_collision_mask_value(4, 0)
		car.carMesh.visible = false
		car.ghostMesh.visible = true
		print("👻 GHOST activated")

	elif num == 3:
		# FIRE ROCKET
		if car.car_rocketRay != null:
			var rocket = car.rocket_Scene.instantiate()
			get_tree().root.add_child(rocket)
			rocket.global_transform.origin = car.car_rocketRay.global_transform.origin
			rocket.global_transform.basis = car.car_rocketRay.global_transform.basis
			print("🚀 ROCKET FIRED")

	else:
		print("⚠️ Unknown powerup:", num)

	car.icon.set_icon_invisible()
	car.powerUpNum = -1
