class_name TrackMenu
extends Control


@onready var smoky_roads = $MarginContainer/HBoxContainer/VBoxContainer/Smoky_roads as Button
@onready var blocky_rock = $"MarginContainer/HBoxContainer/VBoxContainer/Blocky _rock" as Button
@onready var map_select = $MarginContainer/HBoxContainer/VBoxContainer/Map_select as Button

@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var smokyroads = preload("res://Assets/World/Maps/smoky_roads.tscn") as PackedScene
@onready var blockyrock = preload("res://Assets/World/Maps/blocky_rock.tscn") as PackedScene
@onready var map_preview = $SubViewportContainer/MapPreview
@onready var map_selection = ""

func _ready():
	smoky_roads.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	blocky_rock.button_down.connect(on_blocky_pressed)
	map_select.button_down.connect(mapSelected)
	smoky_roads.focus_entered.connect(smokyFocus)
	blocky_rock.focus_entered.connect(blockyFocus)
	
func smokyFocus():
	map_preview.smoky_roads_visible()

func blockyFocus():
	map_preview.blocky_rock_visible()	
	
func on_start_pressed() -> void:
	map_selection = smokyroads	
	
func on_blocky_pressed() -> void:
	map_selection = blockyrock
	
func mapSelected() ->void:
	get_tree().change_scene_to_packed(map_selection)
	
func on_exit_pressed() -> void:
	get_tree().quit()
