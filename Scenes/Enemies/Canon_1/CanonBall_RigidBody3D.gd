extends Area3D
@onready var node_3d = $"../.."
var power = Vector2(5,5)
func _on_Cannonball_body_entered(body):
	print(body.name)
	#body.gravity = 5
	body.rotate_x(1)
