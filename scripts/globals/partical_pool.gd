class_name ParticalPool

const MAX_PARTICALS : int = 10
static var partical_pool : Array = []

static func spawn_partical(global_pos:Vector3,parent:Node3D)->void:
	var partical_instance : GPUParticles3D
	if len(partical_pool) >= MAX_PARTICALS and is_instance_valid(partical_pool[0]):
		partical_instance = partical_pool.pop_front()
		partical_pool.push_back(partical_instance)
		partical_instance.reparent(parent)
	else:
		partical_instance = preload("res://scenes/shatter.tscn").instantiate()
		parent.add_child(partical_instance)
		partical_pool.push_back(partical_instance)
	
	if not is_instance_valid(partical_pool[0]):
		partical_pool.pop_front()
	
	partical_instance.global_position = global_pos
	
	partical_instance.emitting = true
