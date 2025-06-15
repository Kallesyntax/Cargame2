extends Resource
class_name CheckpointManager

var track_laps = Global.max_laps 
#--- Data
var checkpoints := []            # Array<Vector3>
var total_checkpoints := 0       # räknas vid setup
var current_index := 0           # 0-baserat; motsvarar checkpoint 1 i editor
var lap_count := 0               # antal färdiga varv

#--- Initiering: samla checkpoints, sortera, räkna
func setup_from_node(cp_node: Node3D) -> void:
	checkpoints.clear()

	# Hämta bara de child-noder som är av typen CheckpointArea
	var sorted := cp_node.get_children().filter(func(c):
		return c is CheckpointArea
	)

	# Sortera dem numeriskt på checkpointID (1-baserat namn eller exporterat fält)
	sorted.sort_custom(Callable(self, "_sort_by_name_as_int"))

	# Spara positionerna
	for c in sorted:
		checkpoints.append((c as Node3D).global_transform.origin)

	total_checkpoints = checkpoints.size()
	current_index = 0 #Återställ till 0
	lap_count = 0

	print("✅ CheckpointManager: hittade ", total_checkpoints, " checkpoints.")

#--- Hjälpmetod för numerisk sortering av nodnamn
func _sort_by_name_as_int(a: Node, b: Node) -> bool:
	return int(a.name) < int(b.name)

#--- Hämta aktuell checkpointposition
func get_current_checkpoint() -> Vector3:
	return checkpoints[current_index]

#--- Anropas när bilen passerar en checkpoint; checkpoint_id är 1-baserat
#   Returnerar en dict: {ok: bool, lap_finished: bool}
func pass_checkpoint(checkpoint_id: int) -> Dictionary:
	var idx = checkpoint_id - 1
	
	# Fel checkpoint
	if idx != current_index:
		print("⚠️ pass_checkpoint: förväntade checkpoint ", current_index + 1, " men fick ", checkpoint_id)
		return {"ok": false, "lap_finished": false, "finished": false}
	
	# Rätt checkpoint
	current_index += 1
	
	# Om vi gick förbi sista → varv klart
	if current_index >= total_checkpoints:
		current_index = 0

		# Är racet redan klart?
		if lap_count >= track_laps:
			print("🏁 Redan gått i mål – ignorerar extra varv.")
			return {"ok": true, "lap_finished": false, "finished": true}

		# Avsluta varv
		lap_count += 1
		print("🏁 Varv ", lap_count, " avklarat.")

		var is_finished = lap_count >= track_laps
		return {"ok": true, "lap_finished": true, "finished": is_finished}
	
	# Normalt avancemang
	print("➡️ Gick vidare till checkpoint ", current_index + 1, "/", total_checkpoints)
	return {"ok": true, "lap_finished": false, "finished": false}

#--- Reset hela managern
func reset() -> void:
	current_index = 0
	lap_count = 0
