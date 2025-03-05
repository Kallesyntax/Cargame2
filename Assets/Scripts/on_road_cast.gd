extends RayCast3D

func check_ground():
	if self.is_colliding():
		print("On road")
		return true
	else:
		return false
