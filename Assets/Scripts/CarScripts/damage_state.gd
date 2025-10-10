extends CarState

func enter_state():
	car.animation_player.play("Damaged")
	car.engine_force = 0
	car.steering = 0
	car.timer_damage.start()

func physics_update(delta: float):
	pass  # Skada påverkar bara direkt vid enter

func exit_state():
	# Här kan du återställa vad som behövs efter skada, t.ex:
	# car.engine_force = nåt standardvärde
	pass
