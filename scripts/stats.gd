extends Resource
class_name Stats

@export var max_health : float = 100
var health : float = max_health :
	set(value):
		health = value
		if health <= 0:
			no_health.emit()

signal no_health()
