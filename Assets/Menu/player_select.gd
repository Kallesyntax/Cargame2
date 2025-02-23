class_name PlayerCount 
extends Control

@onready var players_1 = %Players1 as Button
@onready var players_2 = %Players2 as Button
@onready var exit_button = %Exit_Button as Button
@onready var start_level = preload("res://Scenes/Menu/car_select.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	players_1.button_down.connect(players_1_pressed)
	players_2.button_down.connect(players_2_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
func players_1_pressed() -> void:
	Global.selected_player_count = 1
	get_tree().change_scene_to_packed(start_level)
	
func players_2_pressed() -> void:
	Global.selected_player_count = 2
	get_tree().change_scene_to_packed(start_level)
	
func on_exit_pressed() -> void:
	get_tree().quit()
