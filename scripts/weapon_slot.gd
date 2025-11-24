extends TextureButton
class_name WeaponSlot

signal next_weapon(w:Weapon)

@export var weapon : Weapon

@onready var panel: ColorRect = $Panel

func setup()-> void:
	texture_normal = weapon.icon
	panel.visible = !weapon.level_to_unlock <= Global.level
	print(weapon.level_to_unlock <= Global.level)


func _on_pressed() -> void:
	next_weapon.emit(weapon)
