extends Control

@onready var result_list = %ResultList
@export var result_row_scene: PackedScene

func _ready():
	populate_results(Global.race_results)

func populate_results(results: Array):
	# Rensa tidigare resultat
	for child in result_list.get_children():
		child.queue_free()

	for i in results.size():
		var row = result_row_scene.instantiate() as ResultRow
		result_list.add_child(row)  # Lägg till i scenen först

		await get_tree().process_frame  # Vänta ett ögonblick

		var data = results[i]
		row.set_data(
			data.position,
			data.name,
			data.time,
			data.points
		)

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	var ms = int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [mins, secs, ms]
