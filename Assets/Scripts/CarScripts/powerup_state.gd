extends CarState

var rocket_scene = preload("res://Scenes/Powerups/Rocket_powerup.tscn")
@onready var fire_node: Node3D = $"../../Exhaust/FireNode"

func enter_state():

	print("powerups")
	if car.powerUpNum != 0:
		car.icon.set_icon_invisible()
		match car.powerUpNum:
			1:
				fire_node.used_fire()
				car.boostSpeed =1000
				await get_tree().create_timer(2.0).timeout
				car.boostSpeed = 0
				fire_node.stop_fire()
			#2:
				#car.timer.start(5)
				#car.set_collision_layer_value(4, false)
				#car.set_collision_mask_value(4, false)
				#car.RealcarMesh.visible = false
				#car.ghostMesh.visible = true
			3:
				if car.car_rocketRay:
					var instance = rocket_scene.instantiate()
					get_tree().root.add_child(instance)
					instance.global_transform = car.car_rocketRay.global_transform
		car.powerUpNum = 0


	state_machine.switch_to_state("DrivingState")

