extends Node
# Global.gd

signal all_players_finished

# Antal spelare som ska spela
var selected_player_count: int = 1

# Valda bilar och hjul per spelare
var selected_car_scenes: Array = []
var selected_wheel_data: Array = []

# Resultat från senaste racet
var race_results: Array = []

# Totalställning över flera race
var total_scores := {}

func _ready():
	reset_race_results()

func reset_race_results():
	race_results.clear()

func total_reset_race_result():
	race_results.clear()
	total_scores.clear()

func add_race_result(name: String, time: float):
	# Undvik dubbletter
	for r in race_results:
		if r.name == name:
			return
	race_results.append({
		"name": name,
		"time": time,
		"points": 0
	})
	if race_results.size() >= selected_player_count:
		finalize_race_results()
		emit_signal("all_players_finished")

func finalize_race_results():
	race_results.sort_custom(func(a, b): return a["time"] < b["time"])
	for i in range(race_results.size()):
		race_results[i]["position"] = i + 1
		var points = get_points_for_position(i + 1)
		race_results[i]["points"] = points

		var player_name = race_results[i]["name"]
		if not total_scores.has(player_name):
			total_scores[player_name] = 0
		total_scores[player_name] += points

func get_points_for_position(pos: int) -> int:
	match pos:
		1: return 10
		2: return 6
		3: return 4
		4: return 2
		_: return 0
