extends Control

@onready var settings: Control = $Settings

func _ready() -> void:
	hide()

func pause()->void:
	visible = !visible
	get_tree().paused = visible
	AudioServer.set_bus_effect_enabled(1,0,visible)
	if visible:
		settings.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed() -> void:
	pause()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	LoadingScreen.start_loading("uid://003381n8cpva")


func _on_options_pressed() -> void:
	settings.show()
