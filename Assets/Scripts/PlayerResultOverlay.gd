extends CanvasLayer
class_name PlayerResultOverlay

@onready var time_label: Label = $Panel/VBoxContainer/TimeTable
@onready var position_label: Label = $Panel/VBoxContainer/PositionLabel

var _pending_time: float = -1.0
var _pending_position: int = -1

func _ready():
	add_to_group("result_overlays")
	# Kolla om tiden och placeringen redan sattes innan scenen var färdig
	if _pending_time >= 0.0:
		set_time(_pending_time)
	if _pending_position > 0:
		set_position(_pending_position)

func set_position(position: int) -> void:
	if position_label:
		position_label.text = "Placering: %d" % position
	else:
		_pending_position = position

func set_time(seconds: float) -> void:
	if time_label:
		var minutes = int(seconds) / 60
		var secs = int(seconds) % 60
		var hundredths = int((seconds - int(seconds)) * 100)
		time_label.text = "Tid: %02d:%02d.%02d" % [minutes, secs, hundredths]
	else:
		_pending_time = seconds
