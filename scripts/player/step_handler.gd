extends Node
class_name StepHandlerComponent

@export_category("Reference")
@export var player : Player
@export var head : CameraController
@export var stairs_ahead: RayCast3D
@export var stairs_below: RayCast3D


@export var max_step_height : float = 0.5
var _snapped_to_stairs_last_frame := false
var last_frame_on_floor : float = -INF

var _saved_camera_global_pos = null

func _ready() -> void:
	stairs_ahead.target_position = Vector3(0,-max_step_height - 0.5,0)
	stairs_below.target_position = Vector3(0,-max_step_height - 0.25,0)

func is_surface_too_steep(normal:Vector3)->bool:
	return normal.angle_to(Vector3.UP) > player.floor_max_angle

func _run_body_test_motion(from:Transform3D,motion:Vector3,result=null)->bool:
	if not result: result = PhysicsTestMotionParameters3D.new()
	var params : PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(player.get_rid(),params,result)

func snap_down_to_stairs_check() -> void:
	var did_snap : bool = false
	var floor_below : bool = stairs_below.is_colliding() and not is_surface_too_steep(stairs_below.get_collision_normal())
	var was_on_floor_last_frame : int = Engine.get_physics_frames() - last_frame_on_floor == 1
	if not player.is_on_floor() and player.velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result : PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(player.global_transform,Vector3(0,-max_step_height,0),body_test_result):
			_save_camera_pos_for_smooth()
			var translate_y : float = body_test_result.get_travel().y
			player.position.y += translate_y
			player.apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap
	
func snap_up_stairs_check(delta) -> bool:
	if not player.is_on_floor() and not _snapped_to_stairs_last_frame: return false
	if player.velocity.y > 0 or (player.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion : Vector3 = player.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance : Transform3D = player.global_transform.translated(expected_move_motion + Vector3(0, max_step_height * 2, 0))
	var down_check_result : KinematicCollision3D = KinematicCollision3D.new()
	if (player.test_move(step_pos_with_clearance, Vector3(0,-max_step_height*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - player.global_position).y
		if step_height > max_step_height or step_height <= 0.01 or (down_check_result.get_position() - player.global_position).y > max_step_height: return false
		stairs_ahead.global_position = down_check_result.get_position() + Vector3(0,max_step_height,0) + expected_move_motion.normalized() * 0.1
		stairs_ahead.force_raycast_update()
		if stairs_ahead.is_colliding() and not is_surface_too_steep(stairs_ahead.get_collision_normal()):
			_save_camera_pos_for_smooth()
			player.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			player.apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _save_camera_pos_for_smooth()->void:
	if not _saved_camera_global_pos:
		_saved_camera_global_pos = head.global_position

func slide_camera_back_to_origin(delta:float)->void:
	if !_saved_camera_global_pos:return
	head.global_position.y = _saved_camera_global_pos.y
	head.position.y = clampf(head.position.y,-.7,.7)
	var move_amount : float = max(player.velocity.length() * delta,player.default_speed/2*delta)
	head.position.y = move_toward(head.position.y,0.0,move_amount)
	_saved_camera_global_pos = head.global_position
	if head.position.y == 0:
		_saved_camera_global_pos = null
	
