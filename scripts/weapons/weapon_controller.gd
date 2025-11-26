extends Node
class_name WeaponController

signal update_ammo

const BULLET_TRACER : PackedScene = preload("res://scenes/bullet_tracer.tscn")

@onready var current_scene : Node3D = get_tree().current_scene.get_node_or_null("Pool")

@export_group("Reference")
@export var player : Player
@export var current_weapon : Weapon
@export var weapon_holder : Node3D
@export var weapon_sfx : AudioStreamPlayer

@export_group("Weapon Effects")
@export var weapon_sway_amount : float = 0.1
@export var weapon_rotation_amount : float = 0.05
@export var invert_weapon_sway : bool = false


var current_weapon_model : Node3D
var anim_player : AnimationPlayer
var muzzle : Node3D

var def_weapon_holder_pos : Vector3
var mouse_input : Vector2

var _shot_hold : bool = false
var raycast : RayCast3D
var max_ammo : int = 0
var ammo : int = 0
var head_shot_multiplier : float = 2.0

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()
		Global.update_powerups.connect(update_magsize)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative

func _process(delta: float) -> void:
	if !current_weapon:return
	weapon_sway(delta)
	weapon_tilt(player._input_dir.x, delta)
	weapon_bob(player._mouvement_velocity.length(), delta)
	
	if Input.is_action_just_pressed("reload") and !anim_player.is_playing() and ammo < max_ammo:
		reload()
	
	if Input.is_action_pressed("fire") and !anim_player.is_playing() and ammo > 0:
		match current_weapon.weapon_type:
			current_weapon.TYPES.SINGLE:
				if !_shot_hold:
					_shot_hold = true
					shoot()
			current_weapon.TYPES.AUTO:
				shoot()
	
	elif Input.is_action_just_released("fire"):
		_shot_hold = false


func spawn_weapon_model()-> void:
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	
	if current_weapon.weapon_scene:
		current_weapon_model = current_weapon.weapon_scene.instantiate()
		weapon_holder.add_child(current_weapon_model)
		current_weapon_model.name = current_weapon.weapon_name
		anim_player = current_weapon_model.get_node_or_null("AnimationPlayer")
		muzzle = current_weapon_model.get_node_or_null("Muzzle")
		raycast = current_weapon_model.get_node_or_null("RayCast3D")
		max_ammo = current_weapon.max_ammo
		ammo = max_ammo
		update_magsize()
		def_weapon_holder_pos = current_weapon_model.position

func reload()->void:
	weapon_sfx.stream = current_weapon.reload_sound
	anim_player.play("reload")
	weapon_sfx.play()
	ammo = max_ammo
	update_ammo.emit(ammo,max_ammo)


func update_magsize()->void:
	
	max_ammo = current_weapon.max_ammo * int(Global.stats["Quantity"])
	ammo = max_ammo
	update_ammo.emit(ammo,max_ammo)


func shoot()->void:
	current_scene = get_tree().current_scene.get_node_or_null("Pool")
	
	weapon_sfx.stream = current_weapon.shoot_sound
	anim_player.play("shoot",-1,Global.stats["FireRate"])
	weapon_holder.add_weapon_kick(0.5,0.8,1.9)
	weapon_sfx.pitch_scale = randf_range(0.9,1.9)
	weapon_sfx.play()
	var bullet_target : Vector3 = raycast.global_transform * raycast.target_position
	
	if raycast.is_colliding():
		var target : Node3D = raycast.get_collider()
		var point : Vector3 = raycast.get_collision_point()
		bullet_target = point
		if target is HurtBox and target.is_in_group("body"):
			target.take_damage(current_weapon.damage * Global.stats["Damage"])
			ParticalPool.spawn_partical(point,current_scene)
		elif target is HurtBox and target.is_in_group("head"):
			target.take_damage(current_weapon.damage * head_shot_multiplier* Global.stats["Damage"])
			ParticalPool.spawn_partical(point,current_scene)
	
	ammo -= 1
	update_ammo.emit(ammo,max_ammo)
	make_bullet_trail(bullet_target)

func make_bullet_trail(target_pos:Vector3)->void:
	if muzzle:
		var bullet_dir : Vector3 = (target_pos-muzzle.global_position).normalized()
		var start_pos : Vector3 = muzzle.global_position + bullet_dir * 0.25
		if (target_pos-start_pos).length() > 3.0:
			var bullet_tracer : Node3D = BULLET_TRACER.instantiate()
			player.add_sibling(bullet_tracer)
			bullet_tracer.global_position = start_pos
			bullet_tracer.target_pos = target_pos
			bullet_tracer.look_at(target_pos)
			
	

func weapon_tilt(input_x:float, delta:float)->void:
	if current_weapon_model:
		current_weapon_model.rotation.z = lerp(current_weapon_model.rotation.z, -input_x * weapon_rotation_amount * 10, 10 * delta)

func weapon_sway(delta:float)->void:
	if current_weapon_model:
		mouse_input = lerp(mouse_input,Vector2.ZERO,10*delta)
		current_weapon_model.rotation.x = lerp(current_weapon_model.rotation.x, mouse_input.y * weapon_rotation_amount * (-1 if invert_weapon_sway else 1), 10 * delta)
		current_weapon_model.rotation.y = lerp(current_weapon_model.rotation.y, mouse_input.x * weapon_rotation_amount * (-1 if invert_weapon_sway else 1), 10 * delta)

func weapon_bob(vel : float, delta:float)->void:
	if current_weapon_model:
		if vel > 0 and player.is_on_floor():
			var bob_amount : float = 0.01
			var bob_freq : float = 0.01
			current_weapon_model.position.y = lerp(current_weapon_model.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			current_weapon_model.position.x = lerp(current_weapon_model.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
			
		else:
			current_weapon_model.position.y = lerp(current_weapon_model.position.y, def_weapon_holder_pos.y, 10 * delta)
			current_weapon_model.position.x = lerp(current_weapon_model.position.x, def_weapon_holder_pos.x, 10 * delta)
