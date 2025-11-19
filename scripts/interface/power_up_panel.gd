extends Control
class_name UpgradeSlot

@export var upgrade : BaseUpgrade
@onready var icon: TextureRect = $MarginContainer/VBoxContainer/Icon
@onready var upgrade_name: Label = $MarginContainer/VBoxContainer/VBoxContainer/UpgradeName
@onready var progress_bar: TextureProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/ProgressBar

const DURATION : float = 0.05

func _ready() -> void:
	update_card()

func update_card()->void:
	if upgrade:
		icon.texture = upgrade.icon
		progress_bar.max_value = upgrade.max_ups
		progress_bar.step = upgrade.max_ups / upgrade.amount

func _on_button_pressed() -> void:
	pass

func _on_button_mouse_entered() -> void:
	_tween("scale",Vector2.ONE * 1.05,DURATION)

func _on_button_mouse_exited() -> void:
	_tween("scale",Vector2.ONE,DURATION)

func _tween(prop:String,new_scale:Vector2,duration:float)->void:
	pivot_offset = size/2
	var tween : Tween = create_tween()
	tween.tween_property(self,prop,new_scale,duration)
