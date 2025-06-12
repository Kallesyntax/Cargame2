extends Control

@onready var select_car = %Select_car
@onready var select_wheels = %Select_Wheels
@onready var Level_select = %Level_select as Button
@onready var start_level = preload("res://Scenes/Menu/stage_select.tscn") as PackedScene
@onready var sub_viewport_container = $SubViewportContainer
@onready var car_preview = %CarPrieview  # Din viewport för förhandsvisning
@onready var playercount = Global.selected_player_count
@onready var player1label =%player1
@onready var player2label =%player2
@onready var animation_player = $CanvasLayer/AnimationPlayer

var red_car_scene = "res://Scenes/Cars/red_car.tscn"
var brown_car_scene = "res://Scenes/Cars/brown_car.tscn"
var green_car_scene = "res://Scenes/Cars/green_car.tscn"
var black_car_scene = "res://Scenes/Cars/black_car.tscn"
var selection_Player = 1  # Håller koll på vilken spelare som väljer

var car_scenes = [
	black_car_scene,
	brown_car_scene,
	green_car_scene,
	red_car_scene
]

var current_car_index = 0  # Bilindex för aktuell förhandsvisning
var player2_car_index = 0  # Separat bilindex för spelare 2

func _ready():
	animation_player.play("Fade_in")
	_update_preview()  # Förhandsvisa första bilen när scenen laddas
	#Level_select.button_down.connect(StartGameButton_pressed)
	select_car.grab_focus()

func _unhandled_input(event):
	# Kontrollera input för spelare 1
	if select_car.is_hovered() or select_car.has_focus():
		if event.is_action_pressed("menu_right") and selection_Player == 1:
			_navigate_right()
		elif event.is_action_pressed("menu_left") and selection_Player == 1:
			_navigate_left()
		elif event.is_action_pressed("menu_select") and selection_Player == 1:
			_confirm_selection()

	# Kontrollera input för spelare 2
	if event.is_action_pressed("menu_right") and selection_Player == 2:
		_navigate_right_player2()
	elif event.is_action_pressed("menu_left") and selection_Player == 2:
		_navigate_left_player2()
	elif event.is_action_pressed("menu_select2") and selection_Player == 2:
		_confirm_selection_player2()

func _confirm_selection():
	if selection_Player == 1:
		Global.selected_car1_scene = car_scenes[current_car_index]
		player1label.text = "Spelare 1 valde: " + car_scenes[current_car_index].get_file().get_basename()
		print("Spelare 1 valde bil:", car_scenes[current_car_index])
		selection_Player = 2  # Växla till spelare 2:s val

func _confirm_selection_player2():
	Global.selected_car2_scene = car_scenes[player2_car_index]
	player2label.text = "Spelare 2 valde: " + car_scenes[player2_car_index].get_file().get_basename()
	print("Spelare 2 valde bil:", car_scenes[player2_car_index])
	print("Båda spelarna har valt sina bilar!")

func _navigate_right():
	current_car_index += 1
	if current_car_index >= car_scenes.size():
		current_car_index = 0
	_update_preview()

func _navigate_left():
	current_car_index -= 1
	if current_car_index < 0:
		current_car_index = car_scenes.size() - 1
	_update_preview()
	
func _navigate_right_player2():
	player2_car_index += 1
	if player2_car_index >= car_scenes.size():
		player2_car_index = 0
	_update_preview()

func _navigate_left_player2():
	player2_car_index -= 1
	if player2_car_index < 0:
		player2_car_index = car_scenes.size() - 1
	_update_preview()

func _update_preview():
	var preview_car_index = current_car_index if selection_Player == 1 else player2_car_index
	print("Uppdaterar förhandsvisning för spelare", selection_Player, ": ", car_scenes[preview_car_index])
	car_preview.update_preview_car(preview_car_index)  # Anropa Viewport-logiken här

func StartGameButton_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
