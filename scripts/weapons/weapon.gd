extends Resource
class_name Weapon

enum TYPES {SINGLE , AUTO , SHOTGUN , LAUNCHER}

@export_group("Setup")
@export var weapon_name : String = ""
@export var weapon_type : TYPES = TYPES.SINGLE
@export var damage : float = 12
@export var max_ammo : int = 12
@export var level_to_unlock : int = 14
@export var next_weapons : Array[Weapon]
@export_subgroup("Projectile")
@export var projectile : PackedScene
@export var projectile_relative_velocity : Vector3 = Vector3(0,0,-15)
@export var projectile_relative_spawn_pos : Vector3 = Vector3(0,0,-3)
@export var projectile_relative_spawn_rot : Vector3 = Vector3(0,0,0)

@export_group("Assets")
@export var icon : Texture2D = preload("res://icon.svg")
@export var weapon_scene : PackedScene
@export var shoot_sound : AudioStream
@export var reload_sound : AudioStream
