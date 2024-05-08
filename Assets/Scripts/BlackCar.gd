extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 1500

@onready var start_level = preload("res://Assets/Menu/car_select.tscn") as PackedScene

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


@export var powerUpNum = 0
@export var boostSpeed = 0

var powerUps = null
var checkpoints = 0
var driving = 0
var look_at
var slidepower =0

# Called when the node enters the scene tree for the first time.
func _ready():	
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position
	powerUps = get_node("/root/PowerUps")
	#checkpoints = get_node("/root/Checkpoints")
	#icon.speedWheel.text = "Tjenare"
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	driving = 0			
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta *2.5)
	if ((RBW.get_rpm() < 550 && (RBW.get_rpm() > - 100)) || (boostSpeed > 1)):
		engine_force = Input.get_axis("ui_down", "Throttle") * ENGINE_POWER + boostSpeed + slidepower		
	else:
		engine_force = 0
		
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 8.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 3.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 3.0)
	camera_3d.look_at(look_at)
	
	if (Input.is_action_pressed("Pause")):	
		get_tree().change_scene_to_packed(start_level)
		
	if (Input.is_action_pressed("Throttle")):		
		smoke_emitt.lifetime = 1				
		driving =1		
		if engine_sound.pitch_scale < 2:
			engine_sound.pitch_scale = engine_sound.pitch_scale +1*delta
		
	else:
		smoke_emitt.lifetime = 1	
		driving = 0	
		if engine_sound.pitch_scale > 0.5:
			engine_sound.pitch_scale = engine_sound.pitch_scale -0.5*delta
			
	if (Input.is_action_pressed("Throttle")):		
		smoke_emitt.lifetime = 0.1		
		engine_force * ENGINE_POWER + boostSpeed + slidepower			
		driving =1		
		if engine_sound.pitch_scale < 2:
			engine_sound.pitch_scale = engine_sound.pitch_scale +1*delta	
				
	if (Input.is_action_pressed("brake") && (RBW.get_rpm()> -100)):		
		smoke_emitt.lifetime = 0.5				
		driving =1		
		engine_force = -5000
		if engine_sound.pitch_scale < 2:
			engine_sound.pitch_scale = engine_sound.pitch_scale +1*delta	
		
	if(Input.is_action_pressed("slide")):
		slidepower = 3000
		RFW.wheel_friction_slip = 0.8
		RBW.wheel_friction_slip = 0.4
		LFW.wheel_friction_slip = 0.8
		LBW.wheel_friction_slip = 0.4		
		# powerUps.used_powerup()
		timer.start()	
		
				
	else:
		slidepower = 0
		RFW.wheel_friction_slip = 1.5
		RBW.wheel_friction_slip = 1.0
		LFW.wheel_friction_slip = 1.5
		LBW.wheel_friction_slip = 1.0

func on_checkpoint_enter():
	checkerpointer.update_checkpointer()
	

func on_powerup_pickup(area):
	powerUpNum = powerUps.get_powerup()
	icon.set_icon_visible(powerUpNum)
	
	
func set_boost_speed(speed):
	boostSpeed = speed

