extends Control

@onready var players1_button: Button          = %Players1
@onready var players2_button: Button          = %Players2
@onready var exit_button: Button              = %Exit_Button
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var car_select_scene: PackedScene    = preload("res://Scenes/Menu/car_select.tscn")

var menu_buttons: Array[Button] = []
var current_index: int          = 0

func _ready() -> void:
	animation_player.play("Fade_in")
	menu_buttons = [ players1_button, players2_button, exit_button ]
	players1_button.button_down.connect(_on_players1_pressed)
	players2_button.button_down.connect(_on_players2_pressed)
	exit_button.button_down.connect(_on_exit_pressed)
	update_focus()

func _unhandled_input(event: InputEvent) -> void:
	# Endast om någon knapp är hovered eller har fokus
	if not (
		players1_button.is_hovered() or players2_button.is_hovered() or exit_button.is_hovered() or
		players1_button.has_focus() or players2_button.has_focus() or exit_button.has_focus()
	):
		return

	if event.is_action_pressed("menu_down"):
		current_index = (current_index + 1) % menu_buttons.size()
		update_focus()
		event.accept()
	elif event.is_action_pressed("menu_up"):
		current_index = (current_index - 1 + menu_buttons.size()) % menu_buttons.size()
		update_focus()
		event.accept()
	elif event.is_action_pressed("menu_select"):
		menu_buttons[current_index].emit_signal("pressed")
		event.accept()

func update_focus() -> void:
	menu_buttons[current_index].grab_focus()

func _on_players1_pressed() -> void:
	Global.selected_player_count = 1

	var pads: PackedInt32Array = Input.get_connected_joypads()
	var dev_id: int
	if pads.size() > 0:
		dev_id = pads[0]
	else:
		dev_id = -1

	Global.selected_player_pads = [ 1 ] 									#Kom ihåg att detta är hårdkodat och att hanteringen bör ligga i player select där device_id registreras från knapptryck, typ join och sedan lagras globalt
	get_tree().change_scene_to_packed(car_select_scene)

func _on_players2_pressed() -> void:
	Global.selected_player_count = 2

	var pads: PackedInt32Array = Input.get_connected_joypads()
	var pad_list: Array[int] = []
	for i in range(2):
		var pad_id: int
		if i < pads.size():
			pad_id = pads[i]
		else:
			pad_id = -1
		pad_list.append(pad_id)

	Global.selected_player_pads = pad_list
	get_tree().change_scene_to_packed(car_select_scene)

func _on_exit_pressed() -> void:
	get_tree().quit()
