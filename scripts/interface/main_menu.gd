extends Control

@onready var settings: Control = $Settings

func _on_start_pressed() -> void:
	Global.reset_stats()
	LoadingScreen.start_loading('uid://dm3gqheyx1prf')

func _on_options_pressed() -> void:
	settings.show()


func _on_quit_pressed() -> void:
	get_tree().quit()
