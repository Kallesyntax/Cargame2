extends Node

@onready var turbo = $CanvasLayer/SubViewportContainer/SubViewport/TurboIcon 
@onready var ghost = $CanvasLayer/SubViewportContainer/SubViewport/GhostIcon
@onready var rocket = $CanvasLayer/SubViewportContainer/SubViewport/RocketIcon
	
func set_icon_visible(powerUpNum):
	if(powerUpNum == 1):
		turbo.visible = 1
	if(powerUpNum== 2):
		ghost.visible = 1
	if(powerUpNum== 3):
		rocket.visible = 1
		
func set_icon_invisible():
	turbo.visible = 0
	ghost.visible = 0
	rocket.visible = 0
