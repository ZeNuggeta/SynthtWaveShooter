extends Control

@onready var sens_slider: HSlider = $Panel/MarginContainer/VBoxContainer/Sens/SensSlider
@onready var vhs_button: Button = $Panel/MarginContainer/VBoxContainer/VHS/VHSButton
@onready var full_screen_button: Button = $Panel/MarginContainer/VBoxContainer/FullScreen/FullScreenButton

func _ready() -> void:
	
	var video_settings : Dictionary = ConfigFileHandler.load_video_setting()
	vhs_button.button_pressed = video_settings.vhs
	full_screen_button.button_pressed = video_settings.fullscreen
	
	
	
	sens_slider.value = Global.sens
	var val_vhs : String = "on" if video_settings.vhs else "off"
	vhs_button.text = val_vhs
	var val_full : String = "on" if video_settings.fullscreen else "off"
	full_screen_button.text = val_full
	
	Global.vhs = video_settings.vhs
	
	
	var control_settings : Dictionary = ConfigFileHandler.load_control_setting()
	sens_slider.value = control_settings.mouse_sens
	
	hide()



func _on_back_button_pressed() -> void:
	hide()



func _on_sens_slider_value_changed(value: float) -> void:
	Global.sens = value
	ConfigFileHandler.save_control_setting("mouse_sens",value)
	



func _on_vhs_button_toggled(toggled_on: bool) -> void:
	Global.vhs = toggled_on
	
	var val_vhs : String = "on" if toggled_on else "off"
	vhs_button.text = val_vhs
	ConfigFileHandler.save_video_setting("vhs",toggled_on)



func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	var val_full : String = "on" if toggled_on else "off"
	full_screen_button.text = val_full
	ConfigFileHandler.save_video_setting("fullscreen",toggled_on)
	
