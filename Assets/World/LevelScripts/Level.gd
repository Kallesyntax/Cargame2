extends Node3D

@export var track_laps = 1
@onready var grid_container_2_player = $GridContainer_2player
@onready var sub_viewports := [
	$GridContainer_2player/SubViewportContainer/SubViewport,
	$GridContainer_2player/SubViewportContainer2/SubViewport2
]
@onready var spawn_points := [
	$P1_spawn,
	$P2_spawn,
	$P3_spawn,
	$P4_spawn
]

func _ready():
	
	if not Global.is_connected("all_players_finished", Callable(self, "_on_race_finished")):
		Global.connect("all_players_finished", Callable(self, "_on_race_finished"))
		
	var player_count = Global.selected_player_count
	grid_container_2_player.visible = player_count > 1

	for i in range(player_count):
		var car_scene = load(Global.get("selected_car%d_scene" % (i + 1)))
		if car_scene and car_scene is PackedScene:
			spawn_player(car_scene, i)
		else:
			push_error("Failed to load car scene for player %d" % (i + 1))


func spawn_player(car_scene: PackedScene, player_index: int):
	var car_instance = car_scene.instantiate()
	var vehicle_body = car_instance.get_node("VehicleBody3D") as BaseCarScript
	vehicle_body.lap_timer.max_laps = track_laps
	if not vehicle_body:
		push_error("VehicleBody3D with BaseCarScript missing for player %d" % (player_index + 1))
		return

	var spawn = spawn_points[player_index]
	var spawn_pos = spawn.global_transform.origin
	var spawn_rot = Vector3(0, -90, 0)
	var rot_radians = spawn_rot * PI / 180.0
	var rotated_basis = Basis().rotated(Vector3.UP, rot_radians.y)

	vehicle_body.transform = Transform3D(rotated_basis, spawn_pos)
	vehicle_body.player_index = player_index

	if player_index == 0 and Global.selected_player_count == 1:
		add_child(car_instance)
	else:
		sub_viewports[player_index].add_child(car_instance)
		
func _on_race_finished():
	print("🏁 Alla spelare i mål, laddar resultatskärm…")

	# Dölj alla result_overlay (till exempel: hitta dem globalt)
	for overlay in get_tree().get_nodes_in_group("result_overlays"):
		overlay.hide()

	# Visa resultat
	var result_screen = preload("res://Scenes/Menu/result_screen.tscn").instantiate()
	get_tree().get_root().add_child(result_screen)

	# Döda banan om du vill
	self.queue_free()
