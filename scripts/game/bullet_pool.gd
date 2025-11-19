extends Node
class_name BulletPool

const BULLET = preload("uid://bntb06f7xtal5")


static func spawn_bullet(reference:Node3D)->void:
	var bullet : Bullet = BULLET.instantiate()
	reference.add_child(bullet)
	bullet.global_position = reference.global_position
	bullet.direction = reference.global_transform.basis.z
	
	
