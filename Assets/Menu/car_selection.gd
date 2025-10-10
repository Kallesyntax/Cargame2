extends Control

class_name CarSelection

@onready var animation_player  = $CanvasLayer/AnimationPlayer
@onready var select_car        = $Select_car
@onready var select_wheels     = $Select_Wheels
@onready var confirm_selection = $Confirm_selection
@onready var Level_select      = $Level_select as Button
@onready var player_labels     = [$player1, $player2, $player3, $player4]

var car_scenes: Array = [
	"res://Scenes/Cars/black_car.tscn",
	"res://Scenes/Cars/brown_car.tscn",
	"res://Scenes/Cars/green_car.tscn",
    "res://Scenes/Cars/red_car.tscn"
]

var wheel_data: Array = [
	load("res://Assets/Resources/Wheels/WheelSprocket.tres"),
	load("res://Assets/Resources/Wheels/OffRoadWheel.tres"),
	load("res://Assets/Resources/Wheels/SpeedWheel.tres")
]

var wheel_names: Array = ["Standardhjul", "Terränghjul", "Snabbhjul"]

var player_count: int
var selected_car_indices: Array   = []
var selected_wheel_indices: Array = []
var selection_player: int = 0

func _ready() -> void:
	
	player_count = Global.selected_player_count

	# Initiera press-to-join-array
	Global.selected_player_pads = []
	for i in range(player_count):
		Global.selected_player_pads.append(-1)
		selected_car_indices.append(0)
		selected_wheel_indices.append(0)
		player_labels[i].text = "Spelare %d ansluten" % [i + 1]

	animation_player.play("Fade_in")
	print("Initierar car_select för", player_count, "spelare")
	_update_preview()
	select_car.grab_focus()
	if player_count == 1 and Global.selected_player_pads[0] == -1:
		var pads = Input.get_connected_joypads()
		if pads.size() > 0:
			Global.selected_player_pads[0] = pads[0]
			player_labels[0].text = "Spelare 1 använder pad %d" % pads[0]
	select_car.grab_focus()

func _unhandled_input(event) -> void:
	# --- Press-to-join för gamepads ---
	if event is InputEventJoypadButton and event.pressed:
		var joy_evt := event as InputEventJoypadButton
		var dev: int = joy_evt.device
		if not Global.selected_player_pads.has(dev):
			for i in range(player_count):
				if Global.selected_player_pads[i] == -1:
					Global.selected_player_pads[i] = dev
					player_labels[i].text = "Spelare %d använder pad %d" % [i+1, dev]
					break
			if not Global.selected_player_pads.has(-1):
				select_car.grab_focus()
		get_tree().set_input_as_handled()
		return

	# --- Befintlig bil-/hjulnavigering ---
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
			_confirm_selection(selection_player + 1)

func _change_car(delta: int) -> void:
	selected_car_indices[selection_player] = wrapi(
		selected_car_indices[selection_player] + delta,
		0,
		car_scenes.size()
	)
	_update_preview()

func _change_wheel(delta: int) -> void:
	selected_wheel_indices[selection_player] = wrapi(
		selected_wheel_indices[selection_player] + delta,
		0,
		wheel_data.size()
	)
	select_wheels.text = "Hjul: " + wheel_names[selected_wheel_indices[selection_player]]
	_update_preview()

func _confirm_selection(ID: int) -> void:
	player_labels[selection_player].text = "Spelare %d valt bil %s och hjul %s" % [
		ID,
		car_scenes[selected_car_indices[selection_player]].get_file().get_basename(),
		wheel_names[selected_wheel_indices[selection_player]]
	]
	selection_player += 1

	if selection_player >= player_count:
		_store_selections()
		Level_select.visible = true
		Level_select.grab_focus()
	else:
		select_car.grab_focus()
		_update_preview()

func _store_selections() -> void:
	Global.selected_car_scenes = []
	Global.selected_wheel_data   = []
	for i in range(player_count):
		# använd load() här, preload kräver statisk sträng
		Global.selected_car_scenes.append(load(car_scenes[selected_car_indices[i]]))
		Global.selected_wheel_data.append(wheel_data[selected_wheel_indices[i]])

func _update_preview() -> void:
	var car_index = selected_car_indices[selection_player]
	var wheel_res = wheel_data[selected_wheel_indices[selection_player]]
	$CarPreview.update_preview_car(car_index, wheel_res)
	select_wheels.text = "Hjul: " + wheel_names[selected_wheel_indices[selection_player]]
