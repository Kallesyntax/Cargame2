extends Node

#var powerUpNum 
@onready var turbo = $SubViewportContainer/SubViewport/TurboIcon
@onready var ghost = $SubViewportContainer/SubViewport/GhostIcon

	
func set_icon_visible(powerUpNum):
	if(powerUpNum == 1):
		turbo.visible = 1
	if(powerUpNum== 2):
		ghost.visible = 1
		
func set_icon_invisible():
		turbo.visible = 0
		ghost.visible = 0
