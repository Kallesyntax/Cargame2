# Global.gd
extends Node

# This variable holds the path to the currently selected car scene.
var selected_car_scene = ""
var selected_player_count = ""

func _ready():
	# Initialize with the default car selection if needed
	selected_car_scene = "res://cars/BlackCar.tscn"
