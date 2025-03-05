extends Control

@onready var select_car = %Select_car
@onready var select_wheels = %Select_Wheels
@onready var Level_select = %Level_select as Button
@onready var start_level = preload("res://Scenes/Menu/stage_select.tscn") as PackedScene
@onready var sub_viewport_container = $SubViewportContainer
@onready var car_prieview = %CarPrieview
@onready var playercount = Global.selected_player_count

var red_car_scene = "res://Scenes/Cars/red_car.tscn"
var brown_car_scene = "res://Scenes/Cars/brown_car.tscn"
var green_car_scene = "res://Scenes/Cars/green_car.tscn"
var black_car_scene = "res://Scenes/Cars/black_car.tscn"

var car_scenes = [
	black_car_scene,
	brown_car_scene,
	green_car_scene,
	red_car_scene
]

var current_car_index = 0

func _ready():
	_preview_car()  # Förhandsvisa första bilen när scenen laddas
	Level_select.button_down.connect(StartGameButton_pressed)
	select_car.grab_focus()
	
func _input(event):
	if select_car.is_hovered() or select_car.has_focus():
		if event is InputEventKey and event.pressed:
			if event.as_text() == "Right":
				_navigate_right()
			elif event.as_text() == "Left":
				_navigate_left()
			elif event.as_text() == "Enter":
				_confirm_selection()

func _navigate_right():
	current_car_index += 1
	if current_car_index >= car_scenes.size():
		current_car_index = 0
	_preview_car()

func _navigate_left():
	current_car_index -= 1
	if current_car_index < 0:
		current_car_index = car_scenes.size() - 1
	_preview_car()

func _preview_car():
	car_prieview.update_preview_car(current_car_index)

func _confirm_selection():
	Global.selected_car1_scene = car_scenes[current_car_index]
	print("Bil vald:", current_car_index)

func StartGameButton_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
