extends Node
class_name StatsHandler

signal health_changed(value:int)

@export var stats : Stats
@export var hurt_box: HurtBox
@export var hurt_sfx : AudioStreamPlayer
@export var look_at_enemy: Node3D

@export var invincible_time : float = 0.7

var _stuned : bool = false
var dead : bool = false


func _ready() -> void:
	stats = stats.duplicate()
	hurt_box.hurt.connect(_take_hit)
	stats.no_health.connect(_player_dead)

func _take_hit(other_hit:HitBox) -> void:
	if dead:return
	if _stuned: return
	
	stats.health -= other_hit.damage
	
	
	look_at_enemy.look_at(other_hit.global_transform.origin,Vector3.UP)
	health_changed.emit(stats.health,look_at_enemy)
	
	hurt_sfx.play()
	
	_stuned = true
	hurt_box.set_deferred("monitoring",false)
	await get_tree().create_timer(invincible_time).timeout
	_stuned = false
	hurt_box.set_deferred("monitoring",true)

func apply_stat_upgrade(upgrade:BaseUpgrade)->void:
	var num : int = upgrade.upgrade_type
	
	Global.global_stats[num] += upgrade.amount[Global.global_levels[num]]
	Global.global_levels[num] += 1
	
	
	#match upgrade.upgrade_type:
		#upgrade.TYPES.HEALTH:
			#Global.max_health_multiplier += upgrade.amount
		#upgrade.TYPES.REGEN:
			#pass
		#upgrade.TYPES.DAMAGE:
			#Global.damage_multiplier += upgrade.amount
		#upgrade.TYPES.FIRERATE:
			#pass
		#upgrade.TYPES.AMMO:
			#pass

func _player_dead() -> void:
	dead = true
