extends VehicleBody3D
class_name CarScript

var active_checkpoint = 1
var active_lap = 1

var MAX_STEER = 0.8
var ENGINE_POWER = 2500
var DEADZONE = 0.1
var powerUpNum = 0
var player_index = 0

func checkpoint_check(area):
	var checknum = area.get_parent().get_parent()
	var checkchild = checknum.get_child_count() - 3
	var ChkInt = int(String(area.name))
	print("num checkpoints: ", checkchild)
	print("checkpointnr: ", active_checkpoint)
	print("Lapnr: ", active_lap)
	if ChkInt != checkchild:
		if ChkInt == active_checkpoint:
			active_checkpoint += 1
			print(active_checkpoint)
		else:
			print("Already been here")
	if ChkInt == checkchild - 1 and active_checkpoint == checkchild:
		active_checkpoint = 1
		active_lap += 1
		if active_lap == 4:
			print("Woho you finished the race!")
		else:
			print("Woho new lap!")

func _process(delta):
	var throttle_action = "player" + str(player_index + 1) + "_throttle"
	var slide_action = "player" + str(player_index + 1) + "_slide"
	var action_action = "player" + str(player_index + 1) + "_action"

	if Input.is_action_pressed(throttle_action):
		# Hantera gasinmatningen
		pass

	if Input.is_action_pressed(slide_action):
		# Hantera slide-inmatningen
		pass

	if Input.is_action_just_pressed(action_action):
		# Hantera action-inmatningen
		pass
