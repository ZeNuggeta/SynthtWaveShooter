extends CharacterBody3D
class_name BaseEnemy

signal no_health
signal damaged

@export_group("References")
@export var stats : Stats
@export var visual : Node3D
@export var mesh : MeshInstance3D
@export var anim : AnimationPlayer
@export_group("Enemy Settings")
@export var speed : float = 3.0
@export var push_force : float = 10.0
@export var turn_speed : float = 15.0
@export var stop_range : float = 0.5
@export var points : int = 150

@onready var eyes: Node3D = $Eyes
@onready var hit_box: HitBox = $HitBox
@onready var soft_collision: SoftCollision = $SoftCollision
@onready var bottom_cast: RayCast3D = $Visuals/BottomCast
@onready var collision_shape: CollisionShape3D = $CollisionShape
@onready var head_hurt_box: HurtBox = $Visuals/Head/HeadHurtBox
@onready var body_hurt_box: HurtBox = $Visuals/BodyHurtBox

var player : Player
var base_mat : ShaderMaterial

const UPDATE_INTERVAL: float = 0.25
var time_elapsed: float = 0.0

var dir : Vector3 

var _is_dead : bool = false
var stun : bool = false

func _ready() -> void:
	stats.no_health.connect(dead)
	body_hurt_box.took_damage.connect(take_damage)
	head_hurt_box.took_damage.connect(take_damage)
	
	base_mat = mesh.get_surface_override_material(0)

func _physics_process(delta: float) -> void:
	if !player:return
	if _is_dead:return
	
	time_elapsed += delta
	if time_elapsed >= UPDATE_INTERVAL:
		tick_update()
		time_elapsed = 0.0
	
	
	
	if player.global_position.y >= self.global_position.y:
		velocity.y = 0.0
	elif player.global_position.y <= self.global_position.y and not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if (eyes.global_position.x != player.global_position.x and eyes.global_position.z != player.global_position.z) and global_position != player.global_position:
		eyes.look_at(player.global_position,Vector3.UP)
		visual.rotation.y = lerp_angle(visual.rotation.y,eyes.rotation.y,turn_speed * delta)
	
	if global_position.distance_to(player.global_position) <= stop_range:return
	
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
	print(value)
	if _is_dead:return
	
	stats.health -= value
	
	base_mat.set_shader_parameter("color_compression",-6)
	stun = true
	
	if !_is_dead:
		Global.points += 10

		damaged.emit()
		await get_tree().create_timer(0.2).timeout
		base_mat.set_shader_parameter("color_compression",6)
		stun = false
	else:
		Global.points += points
		damaged.emit()

func dead()->void:
	_is_dead = true
	anim.pause()
	collision_shape.disabled = true
	no_health.emit()
	hit_box.monitorable = false
	base_mat.set_shader_parameter("color_compression",6)
	queue_free()
