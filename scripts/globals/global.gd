extends Node

signal shake_cam(amount:float,seconds:float)
signal update_xp
signal update_powerups

var game_controller : Node

var kills : int = 0

var stats : Dictionary[String,float] = {
	"Health" : 1.0,
	"Regen" : 1.0,
	"Damage" : 1.0,
	"FireRate" : 1.0,
	"Quantity" : 1.0,
}

var level : int = 40
var experience : float = 0
var experience_total : float = 0
var experience_required : float = get_required_exp(level + 1)
var skill_points : int = 110

var sens : float = 5

func get_required_exp(my_level:int)->int:
	return round(pow(my_level,1.8) + level + 4)

func gain_experience(amount:float)->void:
	experience_total += amount
	experience += amount
	
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	update_xp.emit()

func level_up()->void:
	level += 1
	skill_points += 1
	experience_required = get_required_exp(level + 1)

func upgrade_stats(upgrade:BaseUpgrade,amount:float)->void:
	if skill_points >= upgrade.required_skill_points and stats[upgrade.upgrade_name] < upgrade.max_ups:
		stats[upgrade.upgrade_name] += amount
		skill_points -= upgrade.required_skill_points
		stats[upgrade.upgrade_name] = clampf(stats[upgrade.upgrade_name],1.0,upgrade.max_ups)
		update_powerups.emit()

func reset_stats()->void:
	skill_points = 1
	level = 1
	experience  = 0
	experience_total  = 0
	experience_required = get_required_exp(level + 1)
	kills = 0
	for i in stats:
		stats[i] = 1.0

func shake_camera(amount:float,seconds:float)->void:
	shake_cam.emit(amount,seconds)
