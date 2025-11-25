extends Panel
class_name WeaponPanel


const WEAPON_SLOT = preload("uid://genhxv0a2tl2")

@onready var next_weapon_container: GridContainer = $NextWeaponContainer

var weapon_controller : WeaponController

func _ready() -> void:
	hide()

func update_next_weapon()->void:
	if visible == false:
		show()
		for child in next_weapon_container.get_children():
			child.queue_free()
		var current_weapon : Weapon = weapon_controller.current_weapon
		if current_weapon.next_weapons:
			for i in current_weapon.next_weapons:
				var panel : WeaponSlot = WEAPON_SLOT.instantiate()
				panel.weapon = i
				panel.next_weapon.connect(_weapon_choose)
				next_weapon_container.add_child(panel)
				panel.setup()
		else:
			hide()
	else:
		hide()

func _weapon_choose(weapon:Weapon)->void:
	weapon_controller.current_weapon = weapon
	weapon_controller.spawn_weapon_model()
	for child in next_weapon_container.get_children():
		child.queue_free()
