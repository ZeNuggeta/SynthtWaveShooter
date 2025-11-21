extends Resource
class_name Weapon

enum TYPES {SINGLE , AUTO , SHOTGUN}

@export var weapon_name : String = "weapon"
@export var damage : float = 12
@export var max_ammo : int = 12
@export var weapon_scene : PackedScene
@export var weapon_type : TYPES = TYPES.SINGLE
@export var shoot_sound : AudioStream
@export var reload_sound : AudioStream
