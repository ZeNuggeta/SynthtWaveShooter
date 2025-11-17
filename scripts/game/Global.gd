extends Node

var points : int = 0

var max_health_multiplier : float = 1.0
var regen_multiplier : float = 1.0
var damage_multiplier : float = 1.0
var fire_rate_multiplier : float = 1.0
var ammo_added : int = 1


var global_stats : Array[float] = [1.0,1.0,1.0,1.0,1.0]
var global_levels : Array[int] = [0,0,0,0,0]


func reset_stats()->void:
	max_health_multiplier = 1.0
	regen_multiplier = 1.0
	damage_multiplier = 1.0
	fire_rate_multiplier = 1.0
	ammo_added = 1
