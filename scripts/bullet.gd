extends Node3D
class_name Bullet

const MAX_DISTANCE : float = 50

var speed : float = 9.0
var direction : Vector3
var distance_moved : float = 0

func _physics_process(delta: float) -> void:
	var new_pos : Vector3 =  global_transform.origin - (direction * speed * delta)
	distance_moved += position.distance_to(new_pos)
	position = new_pos
	if distance_moved > MAX_DISTANCE:
		queue_free()
