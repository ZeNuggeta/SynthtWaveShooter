extends Control

@onready var settings: Control = $Settings

func _ready() -> void:
	hide()

func pause()->void:
	visible = !visible
	get_tree().paused = visible
	
	if visible:
		settings.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed() -> void:
	pause()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	LoadingScreen.start_loading("uid://dlh5mphjdwpjg")


func _on_options_pressed() -> void:
	settings.show()
