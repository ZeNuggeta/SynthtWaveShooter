extends Node

signal shake_cam(amount:float,seconds:float)

var points : int = 0

var max_hp : float = 1.0
var regen : float = 1.0
var shield : float = 1.0
var damage : float = 1.0
var fire_rate : float = 1.0
var mag_size : int = 1

var interface : Interface

var level : int = 1
var experience : float = 0
var experience_total : float = 0
var experience_required : float = get_required_exp(level + 1)
var skill_points : int = 0

func get_required_exp(my_level:int)->int:
	return round(pow(my_level,1.8) + level + 4)

func gain_experience(amount:float)->void:
	experience_total += amount
	experience += amount
	
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	interface.update_exp()

func level_up()->void:
	level += 1
	skill_points += 1
	experience_required = get_required_exp(level + 1)

func shake_camera(amount:float,seconds:float)->void:
	shake_cam.emit(amount,seconds)
