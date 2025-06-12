extends Control

@onready var players_1 = %Players1 as Button
@onready var players_2 = %Players2 as Button
@onready var exit_button = %Exit_Button as Button
@onready var start_level = preload("res://Scenes/Menu/car_select.tscn") as PackedScene
@onready var animation_player = $CanvasLayer/AnimationPlayer


var menu_buttons = []
var current_index = 0

func _ready():
	animation_player.play("Fade_in")
	# Skapa en lista med knappar för navigering
	menu_buttons = [players_1, players_2, exit_button]
	
	# Anslut knapp-signalerna till sina respektive funktioner
	players_1.button_down.connect(players_1_pressed)
	players_2.button_down.connect(players_2_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
	# Sätt startfokus på första knappen
	update_focus()

func _unhandled_input(event):
	# Kontrollera om någon av våra knappar är i fokus eller om musen är över dem
	if not (players_1.is_hovered() or players_2.is_hovered() or exit_button.is_hovered() or
			players_1.has_focus() or players_2.has_focus() or exit_button.has_focus()):
		return
	
	# Lyssna på våra egendefinierade handlingar
	if event.is_action_pressed("menu_down"):
		current_index = (current_index + 1) % menu_buttons.size()
		update_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("menu_up"):
		current_index = (current_index - 1) % menu_buttons.size()
		if current_index < 0:
			current_index = menu_buttons.size() - 1
		update_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("menu_select"):
		# Utlöser signalen "pressed" på den markerade knappen
		menu_buttons[current_index].emit_signal("pressed")
		get_tree().set_input_as_handled()

func update_focus():
	menu_buttons[current_index].grab_focus()

func players_1_pressed() -> void:
	Global.selected_player_count = 1
	get_tree().change_scene_to_packed(start_level)

func players_2_pressed() -> void:
	Global.selected_player_count = 2
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
