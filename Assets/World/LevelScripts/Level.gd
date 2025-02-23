# Level.gd
extends Node3D
@onready var playercount = Global.selected_player_count
@onready var sub_viewport = $GridContainer_2player/SubViewportContainer/SubViewport
@onready var sub_viewport_2 = $GridContainer_2player/SubViewportContainer2/SubViewport2
@onready var grid_container_2_player = $GridContainer_2player
@onready var p_1_spawn = $P1_spawn
@onready var p_2_spawn = $P2_spawn

func _ready():
	grid_container_2_player.visible = false
	# Load the selected car scene
	var car_scene = load(Global.selected_car1_scene)
	print(playercount)
	# Ensure car_scene is not null and is indeed a PackedScene
	if car_scene and car_scene is PackedScene:
		var car_instance = car_scene.instantiate()
		# Find the VehicleBody3D node with CarScript
		var vehicle_body = car_instance.get_node("VehicleBody3D")
		if vehicle_body and vehicle_body is BaseCarScript:
			vehicle_body = vehicle_body as BaseCarScript
			# Set the spawn position of the car
			var spawn_position = p_1_spawn.global_transform.origin  # Replace with desired position
			# Set the rotation of the car (example: 90 degrees around the Y axis)
			var rotation_degrees = Vector3(0, -90, 0)  # Replace with desired rotation in degrees
			var rotation_radians = rotation_degrees * PI / 180.0  # Convert degrees to radians
			var rotated_basis = Basis().rotated(Vector3.UP, rotation_radians.y)
			vehicle_body.transform = Transform3D(rotated_basis, spawn_position)
			# Add the car instance to the level
			vehicle_body.player_index = 0
			if playercount == 1:
				add_child(car_instance)
			if playercount != 1:
				grid_container_2_player.visible = true
				var car_scene2 = load(Global.selected_car2_scene)
				if car_scene2 and car_scene2 is PackedScene:
					var car_instance2 = car_scene2.instantiate()
					# Find the VehicleBody3D node with CarScript
					var vehicle_body2 = car_instance2.get_node("VehicleBody3D")
					if vehicle_body2 and vehicle_body2 is BaseCarScript:
						vehicle_body2 = vehicle_body2 as BaseCarScript
						# Set the spawn position of the car
						var spawn_position2 = p_2_spawn.global_transform.origin  # Replace with desired position
						# Set the rotation of the car (example: 90 degrees around the Y axis)
						var rotation_degrees2 = Vector3(0, -90, 0)  # Replace with desired rotation in degrees
						var rotation_radians2 = rotation_degrees * PI / 180.0  # Convert degrees to radians
						var rotated_basis2 = Basis().rotated(Vector3.UP, rotation_radians2.y)
						vehicle_body2.transform = Transform3D(rotated_basis2, spawn_position2)
						# Add the car instance to the level
						vehicle_body2.player_index = 1
						sub_viewport.add_child(car_instance)
						sub_viewport_2.add_child(car_instance2)
		else:
			print("Error: The car instance does not contain a VehicleBody3D node with CarScript.")
	else:
		print("Error: Unable to load the car scene.")
