extends VehicleBody3D
class_name CarScript

var active_checkpoint = 1
var active_lap = 1

var MAX_STEER = 0.8
var ENGINE_POWER = 2500
var DEADZONE = 0.1
var powerUpNum = 0
var player_index = 0

var rocket_Scene = load("res://Scenes/Powerups/Rocket_powerup.tscn")
var instance


func fire_Rocket(Car_cannon):
	# Debugging: Print the state of the FirePoint node
	instance = rocket_Scene.instantiate()
	instance.position = Car_cannon.global_position
	instance.transform.basis = Car_cannon.global_transform.basis
	get_parent().add_child(instance)
	# Rest of the firing logic...
	
func checkpoint_check(area):
	var checknum = area.get_parent()
	var checkchild = checknum.get_child_count()
	var ChkInt = int(String(area.name))
	if ChkInt !=checkchild:
		if ChkInt == active_checkpoint:
			active_checkpoint +=1
			#print(active_checkpoint)
		else:
			print("Already been here")
	if ChkInt == checkchild && active_checkpoint == checkchild:
		active_checkpoint = 1
		active_lap +=1
		if active_lap== 4:
			print ("Woho you finished the race!")
		else:
			print("Woho new lap!")
