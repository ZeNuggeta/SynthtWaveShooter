extends TextureButton
class_name WeaponSlot

signal next_weapon(w:Weapon)

@export var weapon : Weapon

@onready var panel: ColorRect = $Panel
@onready var label: Label = $Label

func setup()-> void:
	texture_normal = weapon.icon
	tooltip_text = "Name : %s\nDamage : %.2f\nMag size : %d" %[weapon.weapon_name,weapon.damage,weapon.max_ammo]
	label.text = "Lv:%d" %weapon.level_to_unlock
	label.visible = !weapon.level_to_unlock <= Global.level
	panel.visible = !weapon.level_to_unlock <= Global.level

func _on_pressed() -> void:
	next_weapon.emit(weapon)
