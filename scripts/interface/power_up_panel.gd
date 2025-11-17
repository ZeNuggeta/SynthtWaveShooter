extends Control
class_name UpgradeSlot

signal my_upgrade(upg:BaseUpgrade)

@export var upgrade : BaseUpgrade

@onready var icon: TextureRect = $MarginContainer/VBoxContainer/Icon

@onready var upgrade_name: Label = $MarginContainer/VBoxContainer/VBoxContainer/UpgradeName
@onready var upgrade_level: Label = $MarginContainer/VBoxContainer/VBoxContainer/UpgradeLevel
@onready var upgrade_percent: Label = $MarginContainer/VBoxContainer/VBoxContainer/UpgradePercent

const DURATION : float = 0.05

func _ready() -> void:
	update_card()
	
func update_card()->void:
	icon.texture = upgrade.icon
	upgrade_name.text = upgrade.upgrade_name
	if Global.global_levels[upgrade.upgrade_type] == 0:
		upgrade_level.text = "New!!!"
	else:
		upgrade_level.text = "Current level : " + str(Global.global_levels[upgrade.upgrade_type])
	upgrade_percent.text = "Multiplier : " + str(Global.global_stats[upgrade.upgrade_type])

func _on_button_pressed() -> void:
	my_upgrade.emit(upgrade)


func _on_button_mouse_entered() -> void:
	_tween("scale",Vector2.ONE * 1.05,DURATION)


func _on_button_mouse_exited() -> void:
	_tween("scale",Vector2.ONE,DURATION)

func _tween(prop:String,new_scale:Vector2,duration:float)->void:
	pivot_offset = size/2
	var tween : Tween = create_tween()
	tween.tween_property(self,prop,new_scale,duration)
