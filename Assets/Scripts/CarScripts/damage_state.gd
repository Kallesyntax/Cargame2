extends CarState

func enter_state():
	car.animation.play("Damaged")
	car.engine_force = 0
	car.steering = 0
	car.timer_damage.start()

func physics_update(delta: float):
	pass  # Skada påverkar bara direkt vid enter

func exit_state():
	car.engine_force = car.engine_force  # Återställs av timer
