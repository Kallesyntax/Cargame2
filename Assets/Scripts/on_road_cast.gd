extends RayCast3D

func check_ground():
	if self.is_colliding():
		return true
	else:
		return false
