extends Control

func resume():
	get_tree().paused = false
	visible = false
	
func pause():
	get_tree().paused = true
	visible = true
	
func testEsc():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()

func _on_button_pressed():
	resume()
	
func _on_button_2_pressed():
	get_tree().reload_current_scene()

func _on_button_3_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
