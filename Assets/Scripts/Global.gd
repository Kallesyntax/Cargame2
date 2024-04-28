# Global.gd
extends Node

# This variable holds the path to the currently selected car scene.
var selected_car_scene = ""

func _ready():
	# Initialize with the default car selection if needed
	selected_car_scene = "res://cars/BlackCar.tscn"
