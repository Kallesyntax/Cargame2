# Global.gd
extends Node

# This variable holds the path to the currently selected car scene.
var selected_car1_scene = ""
var selected_car2_scene = ""
var selected_car3_scene = ""
var selected_car4_scene = ""
var selected_player_count = ""

func _ready():
	# Initialize with the default car selection if needed
	selected_car1_scene = "res://Scenes/Cars/brown_pickup.tscn"
	selected_car2_scene = "res://Scenes/Cars/brown_pickup.tscn"
	selected_car3_scene = "res://Scenes/Cars/brown_pickup.tscn"
	selected_car4_scene = "res://Scenes/Cars/brown_pickup.tscn"
