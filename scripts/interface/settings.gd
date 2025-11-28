extends Control

@onready var sens_slider: HSlider = $Panel/MarginContainer/VBoxContainer/Sens/SensSlider

func _ready() -> void:
	sens_slider.value = Global.sens
	hide()



func _on_back_button_pressed() -> void:
	hide()



func _on_sens_slider_value_changed(value: float) -> void:
	Global.sens = value
