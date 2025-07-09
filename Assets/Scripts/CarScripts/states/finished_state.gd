extends CarState

func enter_state():
	car.engine_force = 0
	car.brake = 1.0
	car.steering = 0
	car.engine_sound.pitch_scale = 0.5

func physics_update(delta: float):
	pass  # Låt bilen stå still eller glida ut på mållinjen

func exit_state():
	pass
