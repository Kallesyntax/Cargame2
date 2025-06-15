extends Control

@onready var result_list = %ResultList
@export var result_row_scene: PackedScene
@onready var Next_level = $"CanvasLayer/LapTimer/MarginContainer/VBoxContainer/ButtonBar/Next Race" as Button
@onready var back = $CanvasLayer/LapTimer/MarginContainer/VBoxContainer/ButtonBar/Back
@onready var exit = $CanvasLayer/LapTimer/MarginContainer/VBoxContainer/ButtonBar/Exit

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Fade_in")
	populate_results(Global.race_results)
	#Next_level.pressed.connect(_on_next_race_pressed)
	Next_level.grab_focus()

func populate_results(results: Array):
	for child in result_list.get_children():
		child.queue_free()

	for i in results.size():
		var row = result_row_scene.instantiate() as ResultRow
		result_list.add_child(row)

		await get_tree().process_frame

		var data = results[i]
		var total_points = Global.total_scores.get(data.name, 0)  # 👈 Hämta totalpoäng

		row.set_data(
			data.position,
			data.name,
			data.time,
			total_points  # 👈 Visa detta istället för bara poäng från detta race
		)


func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	var ms = int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [mins, secs, ms]


func _on_next_race_pressed() -> void:
	var start_level = load("res://Scenes/Menu/stage_select.tscn") as PackedScene
	if start_level:
		self.queue_free()  # Ta bort resultatskärmen
		Global.reset_race_results()
		get_tree().change_scene_to_packed(start_level)
	else:
		push_error("⚠️ Kunde inte ladda stage_select.tscn!")


func _on_back_pressed():
	var main_menu = load("res://Scenes/Menu/main_menu.tscn") as PackedScene
	self.queue_free()
	Global.total_reset_race_result()
	get_tree().change_scene_to_packed(main_menu)
	


func _on_exit_pressed():
	get_tree().quit()
