extends Control

var countdown = 3
var game_started = false

func _ready():
	get_tree().paused = true  # Pausa spelet
	print("timer")
	$Timer.start()
	$Label.text = str(countdown)

func _on_timeout():
	print(countdown)
	countdown -= 1
	if countdown > 0:
		$Label.text = str(countdown)
		$Timer.start()
	else:
		$Label.text = "GO!"
		start_race()

func start_race():
	get_tree().paused = false
	$Label.queue_free()  
