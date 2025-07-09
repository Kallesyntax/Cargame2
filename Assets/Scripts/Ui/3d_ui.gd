extends Node

@export var turbo: MeshInstance3D
@export var ghost: MeshInstance3D
@export var rocket: MeshInstance3D
	
func set_icon_visible(powerUpNum):
	if(powerUpNum == 1):
		turbo.visible = true
	if(powerUpNum== 2):
		ghost.visible = true
	if(powerUpNum== 3):
		rocket.visible = true
		
func set_icon_invisible():
	turbo.visible = false
	ghost.visible = false
	rocket.visible = false
