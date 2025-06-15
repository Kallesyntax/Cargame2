extends Control

@onready var select_car = %Select_car
@onready var select_wheels = %Select_Wheels
@onready var confirm_selection = %Confirm_selection
@onready var Level_select = %Level_select as Button
@onready var start_level = load("res://Scenes/Menu/stage_select.tscn") as PackedScene
@onready var car_preview = %CarPrieview
@onready var animation_player = $CanvasLayer/AnimationPlayer
@onready var player_labels = [%player1, %player2, %player3, %player4]

var car_scenes = [
	"res://Scenes/Cars/black_car.tscn",
	"res://Scenes/Cars/brown_car.tscn",
	"res://Scenes/Cars/green_car.tscn",
	"res://Scenes/Cars/red_car.tscn"
]

var wheel_data = [
	load("res://Assets/Resources/Wheels/WheelSprocket.tres"),
	load("res://Assets/Resources/Wheels/OffRoadWheel.tres"),
	load("res://Assets/Resources/Wheels/SpeedWheel.tres")
]
var wheel_names = ["Standardhjul", "Terränghjul", "Snabbhjul"]

var player_count = Global.selected_player_count
var selection_player = 0
var selected_car_indices = []
var selected_wheel_indices = []
var current_car_index = 0
var current_wheel_index = 0


func _ready():
	animation_player.play("Fade_in")
	print("Initierar car_select för", player_count, "spelare")
	for i in range(player_count):
		selected_car_indices.append(0)
		selected_wheel_indices.append(0)
	_update_preview()
	select_car.grab_focus()

func _unhandled_input(event):
	var but = event.is_pressed()
	if event.is_action_pressed("menu_right"):
		if select_car.has_focus():
			_change_car(1)
		elif select_wheels.has_focus():
			_change_wheel(1)
	elif event.is_action_pressed("menu_left"):
		if select_car.has_focus():
			_change_car(-1)
		elif select_wheels.has_focus():
			_change_wheel(-1)
	elif event.is_action_pressed("menu_select"):
		if confirm_selection.has_focus():
			_confirm_selection(selection_player+1)


func _on_select_wheels_mouse_entered():
	_change_wheel(1)

func _change_car(delta: int):
	current_car_index = wrapi(current_car_index + delta, 0, car_scenes.size())
	_update_preview()

func _change_wheel(delta: int):
	current_wheel_index = wrapi(current_wheel_index + delta, 0, wheel_data.size())
	select_wheels.text = "Hjul: " + wheel_names[current_wheel_index]
	_update_preview()


func _confirm_selection(ID):
	current_car_index = current_car_index
	current_wheel_index = current_wheel_index
	player_labels[selection_player].text = "Spelare %d valt bil %s och hjul %s" % [
		ID,
		car_scenes[current_car_index].get_file().get_basename(),
		wheel_names[current_wheel_index]
	]
	selection_player +=1
	
	if selection_player +1 >= player_count:
		_store_selections()
		Level_select.visible = true
	else:
		# Återställ till nästa spelares val
		current_car_index = selected_car_indices[selection_player]
		current_wheel_index = selected_wheel_indices[selection_player]
		_update_preview()

func _store_selections():
	Global.selected_car_scenes = []
	Global.selected_wheel_data = []
	for i in range(player_count):
		Global.selected_car_scenes.append(car_scenes[current_car_index])
		Global.selected_wheel_data.append(wheel_data[current_wheel_index])

func _update_preview():
	print("selection_player:", selection_player)
	print("selected_car_indices:", selected_car_indices)
	print("selected_wheel_indices:", selected_wheel_indices)
	print("wheel_data size:", wheel_data.size())

	if current_car_index >= car_scenes.size() or current_wheel_index >= wheel_data.size():
		return

	var car_index = current_car_index
	var wheel_resource = wheel_data[current_wheel_index]

	car_preview.update_preview_car(car_index, wheel_resource)
	select_wheels.text = "Hjul: " + wheel_names[current_wheel_index]



func StartGameButton_pressed():
	get_tree().change_scene_to_packed(start_level)
