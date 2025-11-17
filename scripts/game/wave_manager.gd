extends Node
class_name WaveManager

signal update_info
signal enemy_hit(dead:bool)


const OFFSET : Vector3 = Vector3(0,1.0,0)


@onready var spawn_timer: Timer = $SpawnTimer
@onready var intermission_timer: Timer = $IntermissionTimer

@export var spawns : Node3D
@export var enemy_holder : Node3D
@export var player : Player
@export var interface : Interface
@export var waves : Array[Wave]

var _current_enemy : BaseEnemy
var _current_wave : int = -1

const MAX_ENEMYS_ONSCREEN : int = 65
var _enemies_left_to_spawn : int = 0
var _enemies_on_screen : int = 0
var _enemies_left_to_kill : int = 0
var _finished_waves : bool = false

func _ready() -> void:
	_start_next_wave()


func _start_next_wave()->void:
	_current_wave += 1
	if _current_wave <= waves.size() - 1:
		_enemies_left_to_spawn = waves[_current_wave].num_of_enemys
		_enemies_on_screen = 0
		_enemies_left_to_kill = _enemies_left_to_spawn
		update_info.emit(_current_wave + 1,_enemies_left_to_kill)
	else:
		_finished_waves = true

func spawn_enemy(global_pos:Vector3)->void:
	var enemy_instance : BaseEnemy = waves[_current_wave].enemy_variation.pick_random().instantiate()
	
	_current_enemy = enemy_instance
	_current_enemy.player = player
	
	_current_enemy.no_health.connect(_dead_enemy)
	_current_enemy.damaged.connect(_damaged_enemy)
	enemy_holder.add_child(enemy_instance)
	
	enemy_instance.global_position = global_pos
	
	_enemies_left_to_spawn -= 1
	_enemies_on_screen += 1

func _on_spawn_timer_timeout() -> void:
	if _finished_waves or  _enemies_left_to_spawn == 0 or _enemies_on_screen >= MAX_ENEMYS_ONSCREEN:return
	var random_spawn : Marker3D = spawns.get_child(randi_range(0,spawns.get_child_count(false) - 1))
	spawn_enemy(random_spawn.global_position + OFFSET)
	update_info.emit(_current_wave + 1,_enemies_left_to_kill)

func _damaged_enemy()->void:
	if _enemies_left_to_kill == 0:
		update_info.emit(-20)
	else:
		update_info.emit(_current_wave + 1,_enemies_left_to_kill)
	enemy_hit.emit(false)

func _dead_enemy() -> void:
	_enemies_on_screen -= 1
	_enemies_left_to_kill -= 1
	enemy_hit.emit(true)
	
	

func intermission()->void:
	intermission_timer.start()
	update_info.emit(-30,intermission_timer.time_left)


func _on_intermission_timer_timeout() -> void:
	_start_next_wave()
	if !_finished_waves:
		update_info.emit(_current_wave + 1,_enemies_left_to_kill)
	else:
		update_info.emit(-10)
