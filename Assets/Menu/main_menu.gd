class_name MainMenu
extends Control

@onready var start_button = $CanvasLayer2/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $CanvasLayer2/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://Scenes/Menu/player_select.tscn") as PackedScene

var menu_buttons = []
var current_index = 0

func _ready():
	# Skapa en lista med knapparna
	menu_buttons = [start_button, exit_button]
	
	# Koppla knapp-signalernas "button_down" till respektive callback
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
	# Sätt startfokus på första knappen
	menu_buttons[current_index].grab_focus()

func _unhandled_input(event):
	# Hantera endast om någon av våra knappar är i fokus eller om muspekaren är över någon av dem
	if not (start_button.is_hovered() or exit_button.is_hovered() or
			start_button.has_focus() or exit_button.has_focus()):
		return
	
	if event.is_action_pressed("menu_down"):
		current_index = (current_index + 1) % menu_buttons.size()
		update_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("menu_up"):
		current_index = (current_index - 1) % menu_buttons.size()
		# Om current_index blir negativ, gå till sista knappen
		if current_index < 0:
			current_index = menu_buttons.size() - 1
		update_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("menu_select"):
		# Utlöser den valda knappens signal
		menu_buttons[current_index].emit_signal("pressed")
		get_tree().set_input_as_handled()

func update_focus():
	menu_buttons[current_index].grab_focus()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
