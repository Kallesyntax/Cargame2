extends CarState

var rocket_scene = preload("res://Scenes/Powerups/Rocket_powerup.tscn")

func enter_state():
	print("powerups")
	if car.powerUpID.powerUpNum != 0:
		car.icon.set_icon_invisible()
		match car.powerUpID.powerUpNum:
			1:
				car.timer.start(3)
				car.fire.used_fire()
				car.set_boost_speed(1000)
			2:
				car.timer.start(5)
				car.set_collision_layer_value(4, false)
				car.set_collision_mask_value(4, false)
				car.RealcarMesh.visible = false
				car.ghostMesh.visible = true
			3:
				if car.car_rocketRay:
					var instance = rocket_scene.instantiate()
					get_tree().root.add_child(instance)
					instance.global_transform = car.car_rocketRay.global_transform
		car.powerUpID.powerUpNum = 0

	# Gå tillbaka till Idle när klart
	state_machine.switch_to_state("IdleState")
