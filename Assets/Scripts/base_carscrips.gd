extends CarScript

@onready var start_level = preload("res://Assets/Menu/player_select.tscn") as PackedScene

@onready var checkerpointer = $Checkerpointer
@onready var camera_pivot = $camera_pivot
@onready var camera_3d = $camera_pivot/Camera3D
@onready var smoke_emitt = $Exhaust/Smoke
@onready var engine_sound = $EngineSFX
@onready var LFW = $VehicleWheel3D
@onready var RFW = $RFW
@onready var LBW = $VehicleWheel3D2
@onready var RBW = $RBW
@onready var fire_car = $"."
@onready var timer = $Timer
@onready var icon = $"3d_ui"

@export var Acceleration = 1500
@export var Top_Speed = 550
@export var boostSpeed = 0
@export var carMesh: MeshInstance3D
@export var ghostMesh: MeshInstance3D
@export var car_rocketRay: RayCast3D
@export var animation_player: AnimationPlayer

var driving = 0
var look_at
var slidepower = 0
var powerUps = null
var checkpoint = ""

func _ready():      
	powerUps = get_node("/root/PowerUps")
	checkpoint = get_parent().get_node("/root/check_points")
	look_at = global_position
	steering = 0    

func _physics_process(delta):   
	ENGINE_POWER = Acceleration
	var steering_input = Input.get_joy_axis(player_index, 0)
	if abs(steering_input) < DEADZONE:
		steering_input = 0
	driving = 0         
	steering = move_toward(steering, steering_input * -1 * MAX_STEER, delta * 2.5)
	if ((RBW.get_rpm() < Top_Speed && (RBW.get_rpm() > -Top_Speed)) || (boostSpeed > 1)):
		engine_force = Input.get_joy_axis(player_index,  5) * ENGINE_POWER + boostSpeed + slidepower
	else:
		engine_force = 0
	
	if Input.is_action_pressed("Pause"):    
		get_tree().change_scene_to_packed(start_level)
		
	if Input.is_action_pressed("Throttle"):     
		smoke_emitt.lifetime = 1                
		driving = 1     
		if engine_sound.pitch_scale < 2:
			engine_sound.pitch_scale += 1 * delta       
	else:
		smoke_emitt.lifetime = 1    
		driving = 0 
		if engine_sound.pitch_scale > 0.5:
			engine_sound.pitch_scale -= 0.5 * delta
			
	if Input.is_action_pressed("Throttle"):     
		smoke_emitt.lifetime = 0.1      
		engine_force * ENGINE_POWER + boostSpeed + slidepower           
		driving = 1     
		if engine_sound.pitch_scale < 2:
			engine_sound.pitch_scale += 1 * delta   
				
	if Input.is_action_pressed("brake") and RBW.get_rpm() > -100:       
		smoke_emitt.lifetime = 0.5              
		driving = 1     
		engine_force = -5000
		if engine_sound.pitch_scale < 2:
			engine_sound.pitch_scale += 1 * delta
		
	if Input.is_action_pressed("slide"):
		slidepower = 3000
		RFW.wheel_friction_slip = 0.8
		RBW.wheel_friction_slip = 0.4
		LFW.wheel_friction_slip = 0.8
		LBW.wheel_friction_slip = 0.4       
	else:
		slidepower = 0
		RFW.wheel_friction_slip = 1.5
		RBW.wheel_friction_slip = 1.0
		LFW.wheel_friction_slip = 1.5
		LBW.wheel_friction_slip = 1.0
		
func on_checkpoint_enter(area):
	checkpoint_check(area)

func on_powerup_pickup(area):
	powerUpNum = powerUps.get_powerup()
	icon.set_icon_visible(powerUpNum)
	
func set_boost_speed(speed):
	boostSpeed = speed
