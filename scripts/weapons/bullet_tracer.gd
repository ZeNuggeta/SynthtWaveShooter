extends Node3D

var target_pos : Vector3 = Vector3(0,0,0)
var speed : float = 75.0
var tracer_length : float = 1

const MAX_LIFE_TIME : float = 5000

@onready var spawn_timer : float = Time.get_ticks_msec()

func _process(delta: float) -> void:
	var diff : Vector3 = target_pos - global_position
	var add : Vector3 = diff.normalized() * speed * delta
	add = add.limit_length(diff.length())
	global_position += add
	if (target_pos - global_position).length() <= tracer_length or Time.get_ticks_msec() - spawn_timer > MAX_LIFE_TIME:
		queue_free()
