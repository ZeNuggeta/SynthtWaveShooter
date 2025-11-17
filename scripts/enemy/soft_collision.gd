extends Area3D
class_name SoftCollision

func is_colliding()-> bool:
	var areas : Array[Area3D] = get_overlapping_areas()
	
	return areas.size() > 0

func get_push_vector()->Vector3:
	var areas : Array[Area3D] = get_overlapping_areas()
	var push_vector : Vector3 = Vector3.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector
