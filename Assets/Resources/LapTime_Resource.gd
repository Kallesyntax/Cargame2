extends Resource
class_name LapTimer

@export var max_laps: int = 3
@export var best_lap_time := 0.0

var lap_start_time := 0.0
var lap_times := []
var total_time := 0.0
var running := false

func start():
	lap_start_time = Time.get_ticks_msec() / 1000.0
	running = true

func lap_completed() -> float:
	if not running:
		return 0.0
	var now = Time.get_ticks_msec() / 1000.0
	var lap_time = now - lap_start_time
	lap_times.append(lap_time)
	total_time += lap_time
	lap_start_time = now
	update_best_lap_time()
	return lap_time
	
func get_best_lap_time() -> float:
	if lap_times.is_empty():
		return 0.0
	return lap_times.min()
	
func update_best_lap_time():
	best_lap_time = get_best_lap_time()

func get_current_lap_time() -> float:
	if not running:
		return 0.0
	return (Time.get_ticks_msec() / 1000.0) - lap_start_time
