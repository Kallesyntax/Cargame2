extends Node3D

@export var track_laps: int = 2

@onready var grid_container_2_player: Control = $GridContainer_2player
@onready var sub_viewports: Array = [
	$GridContainer_2player/SubViewportContainer/SubViewport,
	$GridContainer_2player/SubViewportContainer2/SubViewport2
]
@onready var spawn_points: Array = [
	$P1_spawn,
	$P2_spawn,
	$P3_spawn,
	$P4_spawn
]

func _ready() -> void:
	# Hämta antal spelare och array-storlekar
	var pc            = Global.selected_player_count
	var car_count     = Global.selected_car_scenes.size()
	var pads_count    = Global.selected_player_pads.size()
	var spawn_count   = spawn_points.size()
	var view_count    = sub_viewports.size()

	# Debug-print för snabb överblick
	print("--- Level._ready DEBUG ---")
	print("  player_count:", pc)
	print("  selected_car_scenes.size():", car_count)
	print("  selected_player_pads.size():", pads_count)
	print("  spawn_points.size():", spawn_count)
	print("  sub_viewports.size():", view_count)
	print("---------------------------")

	# 1) Säkerställ att vi har bilar att spawna
	if car_count == 0:
		push_error("Inga valda bilar! Global.selected_car_scenes är tom.")
		return

	# 2) Säkerställ pad-arrayen, fyll på med -1 (tangentbord) vid behov
	if pads_count < pc:
		push_warning("selected_player_pads är för kort. Förväntade %d men har %d. Fyller på med fallback -1." % [pc, pads_count])
		while Global.selected_player_pads.size() < pc:
			Global.selected_player_pads.append(-1)
		pads_count = Global.selected_player_pads.size()

	# 3) Säkerställ spawn points
	if spawn_count < pc:
		push_error("Inte nog med spawn_points för %d spelare (fanns bara %d)." % [pc, spawn_count])
		return

	# 4) Säkerställ split-screen viewports om fler än 1 spelare
	if pc > 1 and view_count < pc:
		push_error("Inte nog med sub_viewports för %d spelare (fanns bara %d)." % [pc, view_count])
		return

	# 5) Kör på resten av init
	Global.max_laps = track_laps

	if not Global.is_connected("all_players_finished", Callable(self, "_on_race_finished")):
		Global.connect("all_players_finished", Callable(self, "_on_race_finished"))

	grid_container_2_player.visible = pc > 1

	# 6) Spawna spelare – loopa exakt pc gånger
	for i in range(pc):
		var car_scene = Global.selected_car_scenes[i]
		if car_scene is PackedScene:
			spawn_player(car_scene, i)
		else:
			push_error("Global.selected_car_scenes[%d] är inte en PackedScene!" % i)

func spawn_player(car_scene: PackedScene, player_index: int) -> void:
	var car_instance  = car_scene.instantiate()
	var vehicle_body  = car_instance.get_node("VehicleBody3D") as BaseCarScript
	if vehicle_body == null:
		push_error("Saknar VehicleBody3D/BaseCarScript i bilinstans för spelare %d" % (player_index + 1))
		return

	# Sätt upp varvtal och input-device
	vehicle_body.lap_timer.max_laps = track_laps
	vehicle_body.device_id           = Global.selected_player_pads[player_index]
	vehicle_body.player_index        = player_index

	# Placera bilen på rätt spawnpunkt
	var sp = spawn_points[player_index]
	if sp:
		var tf = sp.global_transform
		# Rotera den enligt din bana
		var rot = Basis().rotated(Vector3.UP, deg_to_rad(-90))
		vehicle_body.global_transform = Transform3D(rot, tf.origin)
	else:
		push_error("spawn_points[%d] saknas!" % player_index)
		return

	# Lägg bilen i rätt viewport eller direkt i scenen
	if Global.selected_player_count == 1 and player_index == 0:
		add_child(car_instance)
	else:
		if player_index < sub_viewports.size():
			sub_viewports[player_index].add_child(car_instance)
		else:
			push_error("sub_viewports[%d] saknas!" % player_index)

func _on_race_finished() -> void:
	print("🏁 Alla spelare i mål, laddar resultatskärm…")
	for overlay in get_tree().get_nodes_in_group("result_overlays"):
		overlay.hide()
	var result_screen = preload("res://Scenes/Menu/result_screen.tscn").instantiate()
	get_tree().get_root().add_child(result_screen)
	queue_free()
