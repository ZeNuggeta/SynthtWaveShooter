extends Node

@export var wave_manager : WaveManager

@onready var death: AudioStreamPlayer = $Death
@onready var point: AudioStreamPlayer = $Point
@onready var music: AudioStreamPlayer = $Music
@onready var combo_timer: Timer = $ComboTimer

@export var playlist : Array[AudioStream]

var current_track_index : int = -1
var _in_combo : bool = false

func _ready() -> void:
	wave_manager.enemy_hit.connect(_enemy_hit)
	music.finished.connect(playlist_next)
	randomize()
	playlist.shuffle()
	playlist_next()
	

func playlist_next()->void:
	current_track_index += 1
	if playlist.size() <= current_track_index:
		current_track_index = 0
	music.stream = playlist[current_track_index]
	music.play()

func _enemy_hit(dead : bool)->void:
	if dead:
		death.play()
		return
	
	if _in_combo:
		if point.pitch_scale <= 1.1:
			point.pitch_scale += 0.01
	else:
		point.pitch_scale = 1.0
		_in_combo = true
		combo_timer.start()
	point.play()

func _on_combo_timer_timeout() -> void:
	
	_in_combo = false
