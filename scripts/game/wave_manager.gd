extends Node
class_name WaveManager

signal update_info(text:String)
signal enemy_hit(dead:bool)

const MAX_ENEMYS : int = 45
const OFFSET : Vector3 = Vector3(0,1.0,0)


@export var player : Player
@export_group("Reference")
@onready var enemy_holder: Node3D = $"3DSpace/EnemyHolder"
@onready var spawn_container: Node3D = $"3DSpace/SpawnContainer"
@onready var spawn_timer: Timer = $SpawnTimer
@onready var intermission_timer: Timer = $IntermissionTimer
@export_group("Wave setup")
@export var infinite_waves : bool = true
@export var waves : Array[Wave]
@export var between_round_time : float = 5.0
@export var mob_wait_time : float = 1.0



var wave_displayer : int 
var current_wave : int

var mobs_spawned_per_round : int 
var enemies_to_kill : int
var enemies_left : int
var wave_spawn_ended : bool

var moving_to_next_wave : bool

func _ready() -> void:
	start_waving()


func start_waving()->void:
	current_wave = 0
	wave_displayer = current_wave
	position_to_next_wave()
	intermission_timer.wait_time = between_round_time
	spawn_timer.wait_time = mob_wait_time
	mobs_spawned_per_round = MAX_ENEMYS

func _process(_delta: float) -> void:
	if moving_to_next_wave:
		update_info.emit("%d"%(intermission_timer.time_left + 1))

func position_to_next_wave()->void:
	if enemies_left == 0:
		update_info.emit("Wave finished !!! Starting new wave...",true)
		current_wave +=1
		wave_displayer += 1
		await get_tree().create_timer(1.5).timeout
		if current_wave > waves.size():
			if infinite_waves:
				current_wave = 1
			else:
				update_info.emit("No more waves! Game ended")
				return
		intermission_timer.start()
		moving_to_next_wave = true
		await intermission_timer.timeout
		update_info.emit("Wave started!!!")
		spawn_type()
		moving_to_next_wave = false
		


func spawn_type()->void:
	mobs_spawned_per_round = MAX_ENEMYS
	enemies_to_kill = mobs_spawned_per_round
	print(mobs_spawned_per_round)
	if mobs_spawned_per_round >= 1:
		for i in mobs_spawned_per_round:
			var random_spawn : Marker3D = spawn_container.get_child(randi_range(0,spawn_container.get_child_count(false) - 1))
			var enemy : BaseEnemy = waves[current_wave-1].enemies.pick_random().instantiate()
			
			enemy.damaged.connect(_damaged_enemy)
			enemy.no_health.connect(_dead_enemy)
			enemy.player = player
			enemy.set_difficulty(wave_displayer)
			
			enemy_holder.add_child(enemy)
			enemy.global_position = random_spawn.global_position + OFFSET
			
			mobs_spawned_per_round -= 1
			spawn_timer.start()
			await spawn_timer.timeout
			update_info.emit("Enemies left : %d | Current wave : %d" %[enemies_to_kill,wave_displayer])

func _damaged_enemy()->void:
	enemy_hit.emit(false)

func _dead_enemy()->void:
	enemy_hit.emit(true)
	enemies_to_kill -= 1
	update_info.emit("Enemies left : %d | Current wave : %d" %[enemies_to_kill,wave_displayer])
	if enemies_to_kill == 0:
		position_to_next_wave()
