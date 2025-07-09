extends Control

@onready var resume_button = %Resume
@onready var restart_button = %Restart
@onready var volume_slider = %Master_volume  # Referens till HSlider
@onready var quit_button = %Quit
@onready var debounce_timer = $Timer

var can_toggle = true

func pause():
	print("Pausing game and showing menu")
	get_tree().paused = true
	visible = true
	resume_button.grab_focus()  # Ge fokus till Resume-knappen

func resume():
	print("Resuming game and hiding menu")
	get_tree().paused = false
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("Escape") and can_toggle:
		can_toggle = false
		debounce_timer.start()
		if visible:
			resume()
		else:
			pause()
		
	if event.is_action_pressed("menu_select")and can_toggle:
		if resume_button.has_focus():
			print("Resume selected")
			resume()
		elif restart_button.has_focus():
			print("Restart selected")
			get_tree().reload_current_scene()
		elif quit_button.has_focus():
			print("Quit selected")
			get_tree().quit()
	# Hantera volymjustering
	elif event.is_action_pressed("menu_left") or event.is_action_pressed("menu_right"):
		handle_slider_input(event)

func handle_slider_input(event):
	# Kolla om volymreglaget (HSlider) har fokus
	if volume_slider.has_focus():
		if event.is_action_pressed("menu_left"):
			volume_slider.value = max(volume_slider.value - 0.1, volume_slider.min_value)
			print("Volume decreased to:", volume_slider.value)
		elif event.is_action_pressed("menu_right"):
			volume_slider.value = min(volume_slider.value + 0.1, volume_slider.max_value)
			print("Volume increased to:", volume_slider.value)

#func testEsc():
	## Hantera Escape oavsett fokus för att återuppta spelet
	#if Input.is_action_just_released("Escape") and get_tree().paused:
		#print("Escape pressed: Resuming game")
		#resume()
	#elif Input.is_action_just_released("Escape") and not get_tree().paused:
		#print("Escape pressed: Pausing game")
		#pause()

func _on_button_pressed():
	resume()
	
func _on_button_2_pressed():
	get_tree().reload_current_scene()

func _on_button_3_pressed():
	get_tree().quit()

func _process(_delta):
	pass
	#testEsc()
	
func _on_timer_timeout():
	can_toggle = true
