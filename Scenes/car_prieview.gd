extends Node3D

@onready var black_car = $BlackCar1Mesh
@onready var brown_pickup = $BrownPickup

# Called when the node enters the scene tree for the first time.
func black_car_visible():
	black_car.visible = 1
	brown_pickup.visible = 0

func brown_pickup_visible():
	black_car.visible = 0
	brown_pickup.visible = 1
