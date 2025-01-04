extends Node
@onready var bild = $Sprite2D


@export var UI = SubViewportContainer

var powerup_list =  [1,2,3]

func get_powerup():
	return powerup_list.pick_random()
	
	
