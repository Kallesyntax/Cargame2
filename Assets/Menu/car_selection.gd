# CarSelection.gd
extends Control

@onready var Brown_pickup = $MarginContainer/HBoxContainer/VBoxContainer/Brown_pickup as Button
@onready var Black_car = $MarginContainer/HBoxContainer/VBoxContainer/Black_car as Button
@onready var Level_select = $MarginContainer/HBoxContainer/VBoxContainer/Level_select as Button
@onready var start_level = preload("res://Assets/Menu/stage_select.tscn") as PackedScene
@onready var sub_viewport_container = $SubViewportContainer
@onready var car_prieview = $SubViewportContainer/SubViewport/CarPrieview
@onready var playercount = Global.selected_player_count


var viewport_scene = preload("res://Scenes/car_prieview.tscn")
var black_car_scene = preload("res://Scenes/Cars/fire_car.tscn")
var brown_car_scene = preload("res://Scenes/Cars/brown_pickup.tscn")
var viewport_instance

func _ready():
	print(playercount)
	Black_car.button_down.connect(BlackCarButton_pressed)
	Black_car.focus_entered.connect(BlackCarFocus)
	Brown_pickup.focus_entered.connect(BrownPickupFocus)
	Brown_pickup.button_down.connect(BrownPickupButton_pressed)
	Level_select.button_down.connect(StartGameButton_pressed)
# Button signals to change the selected car

# Button signals to change the selected car
func BlackCarFocus():
	car_prieview.black_car_visible()

func BrownPickupFocus():
	car_prieview.brown_pickup_visible()
	
func BlackCarButton_pressed()-> void:
	Global.selected_car_scene = "res://Scenes/Cars/fire_car.tscn"
# You can add code here to update the UI or preview the selected car
func BrownPickupButton_pressed()-> void:
	Global.selected_car_scene = "res://Scenes/Cars/brown_pickup.tscn"
# Signal to start the game with the selected car
func StartGameButton_pressed()-> void:
	get_tree().change_scene_to_packed(start_level)
	
	
