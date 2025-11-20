extends Node
class_name WeaponController



@export_group("Reference")
@export var player : Player
@export var current_weapon : Weapon
@export var weapon_holder : Node3D
@export var raycast : RayCast3D
@export var weapon_sfx : AudioStreamPlayer

@export_group("Weapon Effects")
@export var weapon_sway_amount : float = 0.1
@export var weapon_rotation_amount : float = 0.05
@export var invert_weapon_sway : bool = false


var current_weapon_model : Node3D
var anim_player : AnimationPlayer


var def_weapon_holder_pos : Vector3
var mouse_input : Vector2

var _shot_hold : bool = false
var head_shot_multiplier : float = 2.0

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative


func _process(delta: float) -> void:
	if !current_weapon:return
	weapon_sway(delta)
	weapon_tilt(player._input_dir.x, delta)
	weapon_bob(player._mouvement_velocity.length(), delta)
	
	
	if Input.is_action_pressed("fire") and !anim_player.is_playing():
		
		match current_weapon.weapon_type:
			current_weapon.TYPES.SINGLE:
				if !_shot_hold:
					_shot_hold = true
					shoot()
			current_weapon.TYPES.AUTO:
				shoot()
	
	if Input.is_action_just_released("fire"):
		_shot_hold = false

func spawn_weapon_model()-> void:
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_holder.add_child(current_weapon_model)
		current_weapon_model.name = current_weapon.weapon_name
		anim_player = current_weapon_model.get_node_or_null("AnimationPlayer")
		def_weapon_holder_pos = current_weapon_model.position


func shoot()->void:
	anim_player.play("shoot",-1,Global.stats["FireRate"])
	weapon_holder.add_weapon_kick(0.1,0.1,0.1)
	weapon_sfx.play()
	if raycast.is_colliding():
		var target : Node3D = raycast.get_collider()
		var point : Vector3 = raycast.get_collision_point()
		if target is HurtBox and target.is_in_group("body"):
			target.take_damage(current_weapon.damage * Global.stats["Damage"])
			ParticalPool.spawn_partical(point,get_tree().current_scene.get_node_or_null("CurrentLevel"))
		elif target is HurtBox and target.is_in_group("head"):
			target.take_damage(current_weapon.damage * head_shot_multiplier* Global.stats["Damage"])
			ParticalPool.spawn_partical(point,get_tree().current_scene.get_node_or_null("CurrentLevel"))


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
