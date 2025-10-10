extends Control

@onready var start_level    = preload("res://Scenes/Menu/stage_select.tscn") as PackedScene
@onready var player_labels  = [%player1, %player2, %player3, %player4]
@onready var Level_select   = %Level_select   as Button

@onready var camera_3d1     = $CanvasLayer/VBoxContainer/ViewportBox/Viewport/SubViewportContainer/SubViewport/Camera3D
@onready var camera_3d2     = $CanvasLayer/VBoxContainer/ViewportBox/Viewport2/SubViewportContainer/SubViewport/Camera3D1
@onready var camera_3d3     = $CanvasLayer/VBoxContainer/ViewportBox/Viewport3/SubViewportContainer/SubViewport/Camera3D2
@onready var camera_3d4     = $CanvasLayer/VBoxContainer/ViewportBox/Viewport4/SubViewportContainer/Subviewport/Camera3D3

@onready var viewport1      = $CanvasLayer/VBoxContainer/ViewportBox/Viewport
@onready var viewport2      = $CanvasLayer/VBoxContainer/ViewportBox/Viewport2
@onready var viewport3      = $CanvasLayer/VBoxContainer/ViewportBox/Viewport3
@onready var viewport4      = $CanvasLayer/VBoxContainer/ViewportBox/Viewport4

@onready var car_preview    = [ camera_3d1, camera_3d2, camera_3d3, camera_3d4 ]
@onready var viewports      = [ viewport1, viewport2, viewport3, viewport4 ]

var car_scenes = [
	load("res://Scenes/Cars/black_car.tscn"),
	load("res://Scenes/Cars/brown_car.tscn"),
	load("res://Scenes/Cars/green_car.tscn"),
	load("res://Scenes/Cars/red_car.tscn")
]

var wheel_data = [
	load("res://Assets/Resources/Wheels/WheelSprocket.tres"),
	load("res://Assets/Resources/Wheels/OffRoadWheel.tres"),
	load("res://Assets/Resources/Wheels/SpeedWheel.tres")
]

var car_names   = ["Svart", "Brun", "Grön", "Röd"]
var wheel_names = ["Standard", "Terräng", "Snabb"]

# ← Här plockar vi upp Global-variablerna som satts i PlayerSelect:
var selected_pads = Global.selected_player_pads   # e.g. [0] eller [0,1] eller [0,-1]
var player_count  = Global.selected_player_count
var player_data   = []

func _ready():
	print("Valda pads:", selected_pads)   # DEBUG: ska visa t.ex. [0,-1] vid två spelare
	Level_select.visible = false
	Level_select.pressed.connect(self._on_Level_select_pressed)

	# Dölj alla
	for vp in viewports:
		vp.visible = false

	# Visa och initiera så många vyportar du valt
	for i in range(player_count):
		viewports[i].visible = true
		player_data.append({
			"device_id":        selected_pads[i],
			"camera_cull_mask": 1,
			"car":              0,
			"wheel":            0,
			"selection_locked": false,
			"menu_index":       0
		})
		_update_label(i)

func _unhandled_input(event):
	if not event.is_pressed():
		return

	# Hitta vilken “player_index” som trycker
	var player_index := -1
	if event is InputEventJoypadButton:
		player_index = selected_pads.find(event.device)
	elif event is InputEventKey:
		# tangentbord har vi kodat som -1 i Global.selected_player_pads
		player_index = selected_pads.find(-1)
	else:
		return

	if player_index < 0 or player_index >= player_count:
		return

	var pdata = player_data[player_index]

	if pdata["selection_locked"]:
		if event.is_action_pressed("menu_back"):
			pdata["selection_locked"] = false
			_update_label(player_index)
			_check_all_selected()
		return

	if event.is_action_pressed("menu_down"):
		pdata["menu_index"] = 1
	elif event.is_action_pressed("menu_up"):
		pdata["menu_index"] = 0

	if event.is_action_pressed("menu_right"):
		if pdata["menu_index"] == 0:
			pdata["car"] = (pdata["car"] + 1) % car_scenes.size()
			for j in range(car_scenes.size()):
				car_preview[player_index].set_cull_mask_value(
					j + 1, j == pdata["car"]
				)
		else:
			pdata["wheel"] = (pdata["wheel"] + 1) % wheel_data.size()
	elif event.is_action_pressed("menu_left"):
		if pdata["menu_index"] == 0:
			pdata["car"] = (pdata["car"] - 1 + car_scenes.size()) % car_scenes.size()
			for j in range(car_scenes.size()):
				car_preview[player_index].set_cull_mask_value(
					j + 1, j == pdata["car"]
				)
		else:
			pdata["wheel"] = (pdata["wheel"] - 1 + wheel_data.size()) % wheel_data.size()

	_update_label(player_index)

	if event.is_action_pressed("menu_select"):
		pdata["selection_locked"] = true
		_update_label(player_index)
		_check_all_selected()

func _update_label(player_index):
	var pdata = player_data[player_index]
	var label = player_labels[player_index]
	var mode  = "Bil" if pdata["menu_index"] == 0 else "Hjul"
	label.text     = "Spelare %d – Bilval: %s | Hjulval: %s [%s]" % [
		player_index + 1,
		car_names[pdata["car"]],
		wheel_names[pdata["wheel"]],
		mode
	]
	label.modulate = Color.GREEN if pdata["selection_locked"] else Color.WHITE

func _check_all_selected():
	for pdata in player_data:
		if not pdata["selection_locked"]:
			Level_select.visible = false
			return
	Level_select.visible = true
	Level_select.grab_focus()

func _on_Level_select_pressed():
	Global.selected_car_scenes  = []
	Global.selected_wheel_data  = []
	for pdata in player_data:
		Global.selected_car_scenes.append(car_scenes[pdata["car"]])
		Global.selected_wheel_data.append(wheel_data[pdata["wheel"]])
	get_tree().change_scene_to_packed(start_level)
