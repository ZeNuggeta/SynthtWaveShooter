extends Control

@onready var sens_slider: HSlider = $Panel/MarginContainer/VBoxContainer/Sens/SensSlider
@onready var vhs_button: Button = $Panel/MarginContainer/VBoxContainer/VHS/VHSButton

func _ready() -> void:
	sens_slider.value = Global.sens
	vhs_button.button_pressed = Global.vhs
	var val : String = "on" if Global.vhs else "off"
	vhs_button.text = val
	hide()



func _on_back_button_pressed() -> void:
	hide()



func _on_sens_slider_value_changed(value: float) -> void:
	Global.sens = value




func _on_vhs_button_toggled(toggled_on: bool) -> void:
	Global.vhs = toggled_on
	var val : String = "on" if Global.vhs else "off"
	vhs_button.text = val
