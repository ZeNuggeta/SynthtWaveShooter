extends CharacterBody3D
class_name BaseEnemy

signal no_health
signal damaged

const CHROME = preload("uid://bps4j05t72kiv")

@export_group("References")
@export var stats : Stats
@export var visual : Node3D
@export var mesh : MeshInstance3D
@export var anim : AnimationPlayer
@export_group("Enemy Settings")
@export_subgroup("Movement")
@export var speed : float = 3.0
@export var turn_speed : float = 15.0
@export var push_force : float = 10.0
@export_subgroup("Attack")
@export var ranged : bool = false
@export var stop_range : float = 1.0
@export var bullet_speed : float = 6.0
@export var attack_speed : float = 1.0
@export_subgroup("Rewards")
@export var xp : int = 10

@onready var eyes: Node3D = $Eyes
@onready var hit_box: HitBox = $HitBox
@onready var soft_collision: SoftCollision = $SoftCollision
@onready var bottom_cast: RayCast3D = $Visuals/BottomCast
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var head_hurt_box: HurtBox = $Visuals/Head/HeadHurtBox
@onready var body_hurt_box: HurtBox = $Visuals/BodyHurtBox
@onready var muzzle: Marker3D = $Visuals/Muzzle
@onready var attack_timer: Timer = $AttackTimer

@onready var current_scene : Node3D = get_tree().current_scene.get_node_or_null("Pool")
@onready var shader : ShaderMaterial = ShaderMaterial.new()

var player : Player
var base_mat : Material

const UPDATE_INTERVAL: float = 0.25
var time_elapsed: float = 0.0

var dir : Vector3 

var _is_dead : bool = false
var _stun : bool = false

func _ready() -> void:
	stats.no_health.connect(dead)
	body_hurt_box.took_damage.connect(take_damage)
	head_hurt_box.took_damage.connect(take_damage)
	
	shader.shader = CHROME
	mesh.set_surface_override_material(0,shader)
	base_mat = mesh.get_surface_override_material(0)

func _physics_process(delta: float) -> void:
	if !player:return
	if _is_dead:return
	
	time_elapsed += delta
	if time_elapsed >= UPDATE_INTERVAL:
		tick_update()
		time_elapsed = 0.0
	
	#if player.global_position.y >= self.global_position.y:
		#velocity.y = 0.0
	#elif player.global_position.y <= self.global_position.y and not is_on_floor():
		#velocity.y += get_gravity().y * delta
	
	if (eyes.global_position.x != player.global_position.x and eyes.global_position.z != player.global_position.z) and global_position != player.global_position:
		eyes.look_at(player.global_position,Vector3.UP)
		visual.rotation.y = lerp_angle(visual.rotation.y,eyes.rotation.y,turn_speed * delta)
	
	if global_position.distance_to(player.global_position) <= stop_range:
		if ranged and !attack_timer.time_left:
			anim.play('stand_range')
			attack_timer.start()
	else:
		attack_timer.stop()
		anim.play('walk')
		move_and_slide()
	
	if soft_collision.is_colliding():
		velocity.x += soft_collision.get_push_vector().x * delta * push_force
		velocity.z += soft_collision.get_push_vector().z * delta * push_force



func tick_update() -> void:
	if !player:return
	dir = player.global_position - global_position
	dir = dir.normalized()
	velocity.x = dir.x * speed 
	velocity.z = dir.z * speed 


func climb()->void:
	velocity.y = 4.0

func take_damage(value:float)->void:
	if _is_dead:return
	stats.health -= value
	
	base_mat.set_shader_parameter("color_compression",-6)
	_stun = true
	
	damaged.emit()
	if not _is_dead:
		await get_tree().create_timer(0.2).timeout
		base_mat.set_shader_parameter("color_compression",6)
		_stun = false

func set_difficulty(difficulty:int)->void:
	stats.max_health = stats.max_health * difficulty
	stats.health = stats.max_health

func dead()->void:
	_is_dead = true
	anim.pause()
	collision_shape.disabled = true
	no_health.emit()
	hit_box.monitorable = false
	base_mat.set_shader_parameter("color_compression",6)
	Global.gain_experience(xp)
	await get_tree().create_timer(0.2).timeout
	queue_free()

func attack()->void:
	BulletPool.spawn_bullet(current_scene,muzzle,bullet_speed)

func _on_attack_timer_timeout() -> void:
	attack()
