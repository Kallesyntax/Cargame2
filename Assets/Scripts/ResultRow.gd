extends Control
class_name ResultRow

@onready var position_label = %Position
@onready var name_label = %Name
@onready var time_label = %Totaltime
@onready var points_label = %Points

func _ready():
	print("🔍 Position label:", position_label)
	print("🔍 Name label:", name_label)
	print("🔍 Time label:", time_label)
	print("🔍 Points label:", points_label)
	
func set_data(position: int, name: String, time: float, points: int) -> void:
	position_label.text = str(position)
	name_label.text = name
	time_label.text = "%.2f s" % time
	points_label.text = str(points)
