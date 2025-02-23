class_name TrackMenu
extends Control


@onready var smoky_roads = %Smoky_roads as Button
@onready var blocky_rock = %"Blocky _rock" as Button
@onready var island_hub = %IslandHub as Button
@onready var map_select = %Map_select as Button
@onready var exit_button = %Exit_Button as Button

@onready var smokyroads = preload("res://Assets/World/Maps/smoky_roads.tscn") as PackedScene
@onready var blockyrock = preload("res://Assets/World/Maps/blocky_rock.tscn") as PackedScene
@onready var ISLAND_HUB = preload("res://Assets/World/Maps/IslandHub/island_hub.tscn") as PackedScene

@onready var map_preview = $CanvasLayer/PanelContainer/SubViewportContainer/SubViewport/MapPreview
@onready var map_selection = ""

func _ready():
	smoky_roads.button_down.connect(on_smoky_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	blocky_rock.button_down.connect(on_blocky_pressed)
	island_hub.button_down.connect(on_islandHub_pressed)
	map_select.button_down.connect(mapSelected)
	smoky_roads.focus_entered.connect(smokyFocus)
	blocky_rock.focus_entered.connect(blockyFocus)
	
func smokyFocus():
	map_preview.smoky_roads_visible()

func blockyFocus():
	map_preview.blocky_rock_visible()	
	
func on_smoky_pressed() -> void:
	map_selection = smokyroads	
	
func on_blocky_pressed() -> void:
	map_selection = blockyrock
	
func on_islandHub_pressed() -> void:
	map_selection = ISLAND_HUB
	
func mapSelected() ->void:
	get_tree().change_scene_to_packed(map_selection)
	
func on_exit_pressed() -> void:
	get_tree().quit()
