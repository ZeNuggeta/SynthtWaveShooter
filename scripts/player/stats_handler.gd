extends Node
class_name StatsHandler

signal health_changed(value:int)

@export var stats : Stats
@export var hurt_box: HurtBox
@export var camera_effect : CameraEffects
@export var hurt_sfx : AudioStreamPlayer
@export var look_at_enemy: Node3D

@export var invincible_time : float = 0.2
@export var regen_time : float = 0

@onready var regen_timer: Timer = $RegenTimer

var _stuned : bool = false
var _can_regent : bool = false
var dead : bool = false

var max_health : float
var health : float

func _ready() -> void:
	stats = stats.duplicate()
	hurt_box.hurt.connect(_take_hit)
	stats.no_health.connect(_player_dead)
	Global.update_powerups.connect(_update_health)
	health = stats.health
	max_health = stats.max_health


func _process(delta: float) -> void:
	if _can_regent:
		health += delta * Global.stats["Regen"]
		health = clampf(health,0.0,max_health)
		health_changed.emit(health,max_health)
		if health >= max_health:
			_can_regent = false

func _update_health()->void:
	max_health = stats.max_health * Global.stats["Health"]
	_can_regent = true
	health_changed.emit(health,max_health)

func _take_hit(other_hit:HitBox) -> void:
	if _stuned: return
	
	
	health -= other_hit.damage
	stats.health = health
	_can_regent = false
	regen_timer.start()
	
	camera_effect.add_damage_kick(2.0,2.0,other_hit.global_transform.origin)
	look_at_enemy.look_at(other_hit.global_transform.origin,Vector3.UP)
	health_changed.emit(health,max_health,look_at_enemy)
	
	hurt_sfx.play()
	
	
	_stuned = true
	hurt_box.set_deferred("monitoring",false)
	await get_tree().create_timer(invincible_time).timeout
	_stuned = false
	hurt_box.set_deferred("monitoring",true)

func _player_dead() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.reset_stats()
	LoadingScreen.start_loading("uid://dlh5mphjdwpjg")


func _on_regen_timer_timeout() -> void:
	_can_regent = true
