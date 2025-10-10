extends Control

@onready var play_button: Button          = $CanvasLayer2/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var exit_button: Button          = $CanvasLayer2/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Exit_Button
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_select_scene: PackedScene  = load("res://Scenes/Menu/player_select.tscn")

var menu_buttons: Array[Button] = []
var current_index: int          = 0

func _ready() -> void:
	#animation_player.play("FadeIn")
	menu_buttons = [ play_button, exit_button ]
	play_button.button_down.connect(_on_play_pressed)
	exit_button.button_down.connect(_on_exit_pressed)
	update_focus()

func _unhandled_input(event: InputEvent) -> void:
	# Hantera bara om vi är över eller har fokus på någon knapp
	if not (
		play_button.is_hovered() or exit_button.is_hovered() or
		play_button.has_focus()    or exit_button.has_focus()
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

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(player_select_scene)

func _on_exit_pressed() -> void:

	get_tree().quit()
