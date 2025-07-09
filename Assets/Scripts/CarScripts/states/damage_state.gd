extends CarState

func enter_state():
	var damaged = car.is_damaged
	pass


func physics_update(delta: float):
	if car.is_damaged == true:
		super.handle_damage(delta)
		car.is_damaged = false
		state_machine.switch_to_state("IdleState")	
		
	

func exit_state():
	# Här kan du återställa vad som behövs efter skada, t.ex:
	# car.engine_force = nåt standardvärde
	pass
