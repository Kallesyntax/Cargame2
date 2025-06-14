extends Node3D

@onready var car_meshes = []

func _ready():
	car_meshes.append($BlackCar)
	car_meshes.append($BrownPickup)
	car_meshes.append($GreenCar)
	car_meshes.append($RedCar)
	_preview_car(0)

func update_preview_car(index: int, wheel_data: WheelData = null):
	_preview_car(index)
	if wheel_data:	
		_apply_wheel_mesh(car_meshes[index], wheel_data.wheel_mesh)

func _preview_car(selected_index: int):
	for i in range(car_meshes.size()):
		car_meshes[i].visible = (i == selected_index)

func _apply_wheel_mesh(car_node: Node3D, wheel_mesh: Mesh):
	for child in car_node.get_children():
		if child is MeshInstance3D and "Wheel" in child.name:
			child.mesh = wheel_mesh
