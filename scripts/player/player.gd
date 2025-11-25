extends CharacterBody3D
class_name Player



@onready var head: Node3D = $Head
@onready var camera_effect: CameraEffects = $Head/Camera
@onready var stand_col: CollisionShape3D = $StandCol
@onready var crouch_col: CollisionShape3D = $CrouchCol
@onready var crouch_check: ShapeCast3D = $CrouchCheck
@onready var step_handler: StepHandlerComponent = $Components/StepHandler
@onready var stats_handler: StatsHandler = $Components/StatsHandler
@onready var weapon_controller: WeaponController = $Components/WeaponController
@onready var state_chart: StateChart = $StateChart

@export_group("Toggles")
@export var can_sprint : bool = true
@export var can_jump : bool = true
@export var can_crouch : bool = true
@export_group("Easing")
@export var acceleration : float = 0.2
@export var deceleration : float = 0.5
@export_group("Speed")
@export var default_speed : float = 5.0
@export var sprint_speed : float = 3.0
@export var crouch_speed : float = -2.0
@export_group("Jump")
@export var jump_velocity : float = 5.0
@export var fall_velocity_threshold : float = -5.0

var _input_dir : Vector2 = Vector2.ZERO
var _mouvement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0 
var _speed : float = 0.0
var curren_fall_velocity : float

func _physics_process(delta: float) -> void:
	if is_on_floor():
		step_handler.last_frame_on_floor = Engine.get_physics_frames()
	else:
		velocity.y += get_gravity().y * delta
	
	var current_velocity : Vector2 = Vector2(_mouvement_velocity.x,_mouvement_velocity.z)
	var speed_modifier : float = sprint_modifier + crouch_modifier
	_speed = default_speed + speed_modifier
	
	_input_dir = Input.get_vector("left","right","front","back")
	var direction : Vector3 = (transform.basis * Vector3(_input_dir.x,0,_input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity,Vector2(direction.x,direction.z) * _speed,acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO,deceleration)
		
	_mouvement_velocity = Vector3(current_velocity.x,velocity.y,current_velocity.y)
	
	velocity = _mouvement_velocity
	
	if not step_handler.snap_up_stairs_check(delta):
		move_and_slide()
		step_handler.snap_down_to_stairs_check()
	step_handler.slide_camera_back_to_origin(delta)

func update_rotation(rotation_input:Vector3)->void:
	global_transform.basis = Basis.from_euler(rotation_input)

func check_fall_speed() -> bool:
	if curren_fall_velocity < fall_velocity_threshold:
		curren_fall_velocity = 0.0
		return true
	else:
		curren_fall_velocity = 0.0
		return false

func walk()->void:
	sprint_modifier = 0.
	
func sprint()->void:
	sprint_modifier = sprint_speed

func stand()->void:
	crouch_modifier = 0.0
	stand_col.disabled = false
	crouch_col.disabled = true
	
func crouch()->void:
	crouch_modifier = crouch_speed
	stand_col.disabled = true
	crouch_col.disabled = false

func jump()->void:
	velocity.y += jump_velocity

func get_input_direction()->Vector2:
	return _input_dir
