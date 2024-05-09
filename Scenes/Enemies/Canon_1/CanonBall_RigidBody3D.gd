extends RigidBody3D
@onready var node_3d = $"../.."

func _on_Cannonball_body_entered(body):
	if body is RigidBody3D or body is VehicleBody3D:
		var relative_velocity = body.linear_velocity + linear_velocity
		var impact_force = 1
		body.apply_impulse(Vector3.ZERO, 1)
