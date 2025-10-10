extends Node

signal all_players_finished

# Konfiguration
var selected_player_count: int = 1
var selected_player_pads: Array = []      # -1 = tangentbord / inte tilldelad
var selected_car_scenes: Array = []       # PackedScene per spelare
var selected_wheel_data: Array = []       # wheel-resource per spelare

# Race‐data
var race_results: Array = []
var total_scores: Dictionary = {}
var max_laps: int = 0

func _ready() -> void:
	reset_race_results()

func reset_race_results() -> void:
	race_results.clear()

func total_reset_race_result() -> void:
	race_results.clear()
	total_scores.clear()

func add_race_result(name: String, time: float) -> void:
	for entry in race_results:
		if entry.name == name:
			return
	race_results.append({
		"name": name,
		"time": time,
		"points": 0
	})
	if race_results.size() >= selected_player_count:
		finalize_race_results()
		emit_signal("all_players_finished")

func finalize_race_results() -> void:
	race_results.sort_custom(func(a, b):
		return a["time"] < b["time"]
	)
	for i in range(race_results.size()):
		var entry = race_results[i]
		entry["position"] = i + 1
		var pts = get_points_for_position(i + 1)
		entry["points"] = pts
		var pname = entry["name"]
		if not total_scores.has(pname):
			total_scores[pname] = 0
		total_scores[pname] += pts

func get_points_for_position(pos: int) -> int:
	match pos:
		1: return 10
		2: return 6
		3: return 4
		4: return 2
		_: return 0
