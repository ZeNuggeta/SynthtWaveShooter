extends Node
class_name WaveManager

signal next_wave_wait 
signal enemy_hit(dead:bool)

const OFFSET : Vector3 = Vector3(0,1.0,0)

@export var player : Player
@export var enemy_holder  : Node3D
@export var spawn_container : Node3D
@export var enemies : Array[PackedScene]
@export var starting_spawn : int = 14
@export var between_round_time : float = 3.0
@export var mob_wait_time : float = 2.0

var current_wave : int


var enemies_to_kill : int
var enemies_left : int
var wave_spawn_ended : bool

var moving_to_next_wave : bool


func _ready() -> void:
	current_wave = 0
	position_to_next_wave()

func position_to_next_wave()->void:
	if enemies_left == 0:
		next_wave_wait.emit()
		current_wave +=1
		await get_tree().create_timer(between_round_time).timeout
		if mob_wait_time > 0.2:
			mob_wait_time -= 0.1
		spawn_type(starting_spawn)
		


func spawn_type(mob_spawn:int)->void:
	var mob_spawn_rounds : int = mob_spawn * current_wave
	enemies_to_kill += mob_spawn_rounds
	
	if mob_spawn_rounds >= 1:
		for i in mob_spawn_rounds:
			var random_spawn : Marker3D = spawn_container.get_child(randi_range(0,spawn_container.get_child_count(false) - 1))
			var enemy : BaseEnemy = enemies[1].instantiate()
			enemy.damaged.connect(_damaged_enemy)
			enemy.no_health.connect(_dead_enemy)
			enemy.player = player
			enemy.set_difficulty(current_wave)
			enemy_holder.add_child(enemy)
			enemy.global_position = random_spawn.global_position + OFFSET
			mob_spawn_rounds -= 1 
			await get_tree().create_timer(mob_wait_time).timeout
		
func _damaged_enemy()->void:
	enemy_hit.emit(false)

func _dead_enemy()->void:
	enemies_to_kill -= 1
	if enemies_to_kill == 0:
		position_to_next_wave()
