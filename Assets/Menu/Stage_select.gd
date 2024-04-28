class_name TrackMenu
extends Control


@onready var smoky_roads = $MarginContainer/HBoxContainer/VBoxContainer/Smoky_roads as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://Assets/World/Maps/smoky_roads.tscn") as PackedScene

func _ready():
	smoky_roads.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
	
func on_exit_pressed() -> void:
	get_tree().quit()
