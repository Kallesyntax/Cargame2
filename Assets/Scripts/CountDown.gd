extends Control

var countdown = 3
var game_started = false

func _ready():
	$Timer.start()
	$Label.text = str(countdown)
	get_tree().paused = true  # Pausa spelet

func _on_Timer_timeout():
	countdown -= 1
	if countdown > 0:
		$Label.text = str(countdown)
		$Timer.start()
	else:
		$Label.text = "GO!"
		start_race()

func start_race():
	get_tree().paused = false  # Återuppta spelet
	$Label.queue_free()  # Ta bort nedräkningsetiketten
