extends Control
class_name UpgradePanel

@export var upgrade : BaseUpgrade
@onready var icon: TextureRect = $MarginContainer/VBoxContainer/Icon
@onready var upgrade_name: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/UpgradeName
@onready var skill_needed: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/SkillNeeded
@onready var progress_bar: TextureProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/ProgressBar


const DURATION : float = 0.05

func _ready() -> void:
	Global.update_powerups.connect(update_card)


func update_card()->void:
	if upgrade:
		icon.texture = upgrade.icon
		upgrade_name.text = upgrade.upgrade_name
		progress_bar.max_value = upgrade.max_ups - 1
		progress_bar.step = upgrade.amount
		progress_bar.value = Global.stats[upgrade.upgrade_name] - 1
		skill_needed.text = "Points : %d" %upgrade.required_skill_points

func _on_button_pressed() -> void:
	if upgrade :
		Global.upgrade_stats(upgrade,upgrade.amount)

func _on_button_mouse_entered() -> void:
	_tween("scale",Vector2.ONE * 1.05,DURATION)

func _on_button_mouse_exited() -> void:
	_tween("scale",Vector2.ONE,DURATION)

func _tween(prop:String,new_scale:Vector2,duration:float)->void:
	pivot_offset = size/2
	var tween : Tween = create_tween()
	tween.tween_property(self,prop,new_scale,duration)
