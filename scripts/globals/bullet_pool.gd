class_name BulletPool

const BULLET = preload("uid://bntb06f7xtal5")

const MAX_BULLETS : int = 60
static var bullet_pool : Array = []

static func spawn_bullet(parent:Node3D,muzzle:Node3D,speed:float)->void:
	var bullet : Bullet
	if len(bullet_pool) >= MAX_BULLETS and is_instance_valid(bullet_pool[0]):
		bullet = bullet_pool.pop_front()
		bullet_pool.push_back(bullet)
		bullet.reparent(parent)
	else:
		bullet = BULLET.instantiate()
		parent.add_child(bullet)
		bullet_pool.push_back(bullet)
	
	if not is_instance_valid(bullet_pool[0]):
		bullet_pool.pop_front()
	
	bullet.speed = speed 
	bullet.global_position = muzzle.global_position
	bullet.direction = muzzle.global_transform.basis.z
	
