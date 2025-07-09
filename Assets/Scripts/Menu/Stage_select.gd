class_name TrackMenu
extends Control

@onready var smoky_roads = %Smoky_roads as Button
@onready var blocky_rock  = %"Blocky _rock" as Button
@onready var island_hub    = %IslandHub as Button
@onready var map_select    = %Map_select as Button
@onready var exit_button   = %Exit_Button as Button

@onready var smokyroads = load("res://Assets/World/Maps/Smokyroad/smoky_roads.tscn") as PackedScene
@onready var blockyrock = load("res://Assets/World/Maps/blocky_rock.tscn") as PackedScene
@onready var ISLAND_HUB = load("res://Assets/World/Maps/IslandHub/island_hub.tscn") as PackedScene

@onready var map_preview = $CanvasLayer/PanelContainer/SubViewportContainer/SubViewport/MapPreview
@onready var map_selection = ""

@onready var animation_player = $CanvasLayer/AnimationPlayer

var buttons = []
var current_index = 0

func _ready():
	animation_player.play("Fade_in")
	# Samla alla knappar i en lista och anslut signaler
	buttons = [smoky_roads, blocky_rock, island_hub, map_select, exit_button]
	smoky_roads.button_down.connect(on_smoky_pressed)
	blocky_rock.button_down.connect(on_blocky_pressed)
	island_hub.button_down.connect(on_islandHub_pressed)
	map_select.button_down.connect(mapSelected)
	exit_button.button_down.connect(on_exit_pressed)
	
	# Uppdatera preview vid fokus på vissa knappar
	smoky_roads.focus_entered.connect(smokyFocus)
	blocky_rock.focus_entered.connect(blockyFocus)
	
	# Sätt startfokus
	update_focus()

func _unhandled_input(event):
	# Endast aktivera menyrörelser om vi befinner oss "i" denna meny 
	# (alltså om någon av våra knappar är i fokus eller muspekaren är över någon av dem)
	if not (smoky_roads.is_hovered() or blocky_rock.is_hovered() or
			island_hub.is_hovered() or map_select.is_hovered() or
			exit_button.is_hovered() or has_focus()):
		return
	
	# Lyssna på våra egna egendefinierade input actions – de ska vara bundna enbart till t.ex. kontroller
	if event.is_action_pressed("menu_down"):
		current_index = (current_index + 1) % buttons.size()
		update_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("menu_up"):
		current_index = (current_index - 1) % buttons.size()
		update_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("menu_select"):
		buttons[current_index].emit_signal("pressed")
		get_tree().set_input_as_handled()

func update_focus():
	buttons[current_index].grab_focus()

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

func mapSelected() -> void:
	get_tree().change_scene_to_packed(map_selection)

func on_exit_pressed() -> void:
	get_tree().quit()
