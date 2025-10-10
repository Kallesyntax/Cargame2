extends Area3D
class_name CheckpointArea

@export var checkpointID: int = 1

signal checkpoint_entered(checkpoint_id)

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.has_method("on_checkpoint_entered"):
		emit_signal("checkpoint_entered", checkpointID)
