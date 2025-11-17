extends Resource
class_name Stats

@export var max_health : float = 100
@export var health : float = 100 :
	set(value):
		health = value
		if health <= 0:
			no_health.emit()

signal no_health()
