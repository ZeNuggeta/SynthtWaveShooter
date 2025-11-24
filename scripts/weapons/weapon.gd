extends Resource
class_name Weapon

enum TYPES {SINGLE , AUTO , SHOTGUN}

@export_group("Setup")
@export var weapon_name : String = ""
@export var weapon_type : TYPES = TYPES.SINGLE
@export var damage : float = 12
@export var max_ammo : int = 12
@export var level_to_unlock : int = 14
@export var next_weapons : Array[Weapon]

@export_group("Assets")
@export var icon : Texture2D = preload("res://icon.svg")
@export var weapon_scene : PackedScene
@export var shoot_sound : AudioStream
@export var reload_sound : AudioStream
