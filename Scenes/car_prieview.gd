extends Node3D

@onready var car_meshes = []  # Lista för att hålla alla bilmesher

func _ready():
	# Lägg till alla bilmesher till listan
	car_meshes.append($BlackCar)
	car_meshes.append($BrownPickup)
	car_meshes.append($GreenCar)
	car_meshes.append($RedCar)

	# Lägg till fler bilmesher här om du har fler bilar i din scen
	_preview_car(0)  # Förhandsvisa första bilen när scenen laddas

func _preview_car(selected_index):
	for i in range(car_meshes.size()):
		car_meshes[i].visible = (i == selected_index)

# Använd denna funktion för att uppdatera bilens synlighet
func update_preview_car(index):
	_preview_car(index)
