extends VehicleBody3D
class_name BaseCarScript

signal race_finished(car_name: String, total_time: float)

@onready var start_level = preload("res://Scenes/Menu/player_select.tscn") as PackedScene
#@onready var checkerpointer = $Checkerpointer
#@onready var camera_pivot = $camera_pivot
#@onready var camera_3d = $camera_pivot/Camera3D
@onready var engine_sound = $EngineSFX
@onready var LFW = $VehicleWheel3D
@onready var RFW = $RFW
@onready var LBW = $VehicleWheel3D2
@onready var RBW = $RBW
@onready var fire_car = $"."
@onready var timer = $Timer
@onready var icon = $Car_ui
@onready var damage_area = $DamageArea
@onready var exhaust = $Exhaust
@onready var state = $state
@onready var respawn_point = $RespawnPoint
@onready var respawn_timer = $RespawnPoint/Timer
@onready var on_road_cast = $OnRoadCast

@export var checkpoint_manager: CheckpointManager = CheckpointManager.new()
@export var lap_timer: LapTimer = LapTimer.new()

@export_group("Bilvariabler")
@export var Acceleration = 1500
@export var Top_Speed = 550
@export var boostSpeed = 0
@export var traction = 3
@export var weight = 300

@export_group("Bildelar")

@export var collisionMesh: CollisionShape3D
@export var carMesh: MeshInstance3D
@export var RealcarMesh: MeshInstance3D
@export var ghostMesh: MeshInstance3D
@export var exhausPosition: Node3D  # Exportera position för avgasrör
@export var car_rocketRay: RayCast3D
@export var animation_player: AnimationPlayer



var active_checkpoint = 11
var active_lap = 1

var MAX_STEER = 0.3
var ENGINE_POWER = 1500
var DEADZONE = 0.1
var powerUpNum = 0
var player_index = 0

var look_at
var slidepower = 0
var powerUps = null
var checkpoint = ""

func _ready():
	
	# Skapa kollision för bilens kropp
	if carMesh and carMesh.mesh:
		var collision_shape_body = CollisionShape3D.new()
		var shape_body = create_convex_collision_shape(carMesh.mesh)
		collision_shape_body.shape = shape_body
		add_child(collision_shape_body)

		# Skapa kollision för DamageArea
		var collision_shape_damage = CollisionShape3D.new()
		var shape_damage = create_convex_collision_shape(carMesh.mesh)
		collision_shape_damage.shape = shape_damage
		damage_area.add_child(collision_shape_damage)

	# Leta rekursivt upp noden som heter "Checkpoints"
	print("🔍 [READY] Letar efter 'Checkpoints' i scenen…")
	var root = get_tree().get_current_scene()
	var cp_parent = _find_checkpoints(root)
	if cp_parent == null:
		push_error("🚨 Kunde inte hitta noden 'Checkpoints' via rekursiv sökning!")
		return
	print("🔍 Hittade Checkpoints-nod på:", cp_parent.get_path())

	# Initiera CheckpointManager
	checkpoint_manager.setup_from_node(cp_parent)
	print("✅ Checkpoints loaded:", checkpoint_manager.total_checkpoints)

	# Koppla checkpoint_entered-signalen från varje CheckpointArea
	for cp in cp_parent.get_children():
		if cp is CheckpointArea:
			print("🔗 Kopplar signal från checkpoint:", cp.checkpointID)
			cp.connect("checkpoint_entered", Callable(self, "on_checkpoint_entered"))

	# Befintlig exhaust-setup
	if exhausPosition:
		exhaust.global_transform.origin = exhausPosition.global_transform.origin

	# Övrig initiering
	mass = weight
	powerUps = get_node("/root/PowerUps")
	checkpoint = get_parent().get_node("/root/Checkpoints")
	look_at = global_position
	steering = 0

	# Starta lap-timern
	lap_timer.start()
	print("🕒 Lap timer started (max laps:", lap_timer.max_laps, ")")
  
func _find_checkpoints(node: Node) -> Node:
	if node.name == "Checkpoints":
		return node
	for child in node.get_children():
		var found = _find_checkpoints(child)
		if found:
			return found
	return null
	
func create_convex_collision_shape(mesh: Mesh) -> ConvexPolygonShape3D:
	var tool = MeshDataTool.new()
	tool.create_from_surface(mesh, 0)
	var vertices = []
	for i in range(tool.get_vertex_count()):
		vertices.append(tool.get_vertex(i))
	var shape = ConvexPolygonShape3D.new()
	shape.set_points(vertices)
	return shape

func _physics_process(delta):   
	ENGINE_POWER = Acceleration
	# Check input actions
	var steering_input = Input.get_joy_axis(player_index, 0)
	var throttle_action = "player" + str(player_index + 1) + "_throttle"
	var drift_action = "player" + str(player_index + 1) + "_drift"
	var action_action = "player" + str(player_index + 1) + "_action"
	var brake_action = "player" + str(player_index + 1) + "_brake"
	var reset_action = "player" + str(player_index + 1) + "_reset"
	
	if abs(steering_input) < DEADZONE:
		steering_input = 0      
	steering = move_toward(steering, steering_input * -1 * (MAX_STEER * state.steer), delta * 2.5)
	if ((RBW.get_rpm() < Top_Speed && (RBW.get_rpm() > -Top_Speed)) || (boostSpeed > 1)):
		#print("Gasning!")
		engine_force = Input.get_joy_axis(player_index,  5) * ENGINE_POWER + boostSpeed + slidepower
	else:
		engine_force = 0
	
	if Input.is_action_pressed(reset_action):
		self.global_position = respawn_point.global_position

func on_checkpoint_enter(area):
	checkpoint_check(area)

func on_powerup_pickup(area):
	powerUpNum = powerUps.get_powerup()
	icon.set_icon_visible(powerUpNum)
	
func set_boost_speed(speed):
	boostSpeed = speed

func checkpoint_check(area):
	var chk_int = int(area.name)
	var result = checkpoint_manager.pass_checkpoint(chk_int)

	if not result.ok:
		print("⚠️ Fel checkpoint. Förväntade:", checkpoint_manager.current_index, "men fick:", chk_int)
		return

	print("✅ Checkpoint ok:", chk_int, "/", checkpoint_manager.total_checkpoints)

	if result.lap_finished:
		var lap_time = lap_timer.lap_completed()
		print("🏁 Varv", checkpoint_manager.lap_count, "klar på", lap_time, "s")

	if result.finished:
		print("🎉 Lopp klart!")

		# Stoppa timern
		var total_time = lap_timer.total_time

		# Visa overlay
		var overlay = preload("res://Scenes/Menu/player_result_overlay.tscn").instantiate()
		overlay.set_time(total_time)
		get_viewport().add_child(overlay)

		# Inaktivera kontroll
		set_process(false)
		set_physics_process(false)

		# Registrera resultat – Global tar hand om resten
		var car_name = "Player: "+str(player_index)
		if car_name == "":
			car_name = "No_Name_%d" % player_index
		Global.add_race_result(car_name, total_time)

			
func _on_timer_timeout():
	if on_road_cast.check_ground():
		respawn_point.position = exhaust.global_position
		respawn_timer.start(1)
