extends Node3D

@onready var smoky_roads = $SmokyRoads
@onready var blocky_rock = $BlockyRock
@onready var IslandHub = $IslandHub


# Called when the node enters the scene tree for the first time.
func smoky_roads_visible():
	smoky_roads.visible = 1
	blocky_rock.visible = 0
	IslandHub.visible = 0

func blocky_rock_visible():
	smoky_roads.visible = 0
	blocky_rock.visible = 1
	IslandHub.visible = 0

func IslandHub_visible():
	smoky_roads.visible = 0
	blocky_rock.visible = 0
	IslandHub.visible = 1
