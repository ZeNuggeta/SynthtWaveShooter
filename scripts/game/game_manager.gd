extends Node

@export var dev_mode : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_exit"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("dev_reload"):
		get_tree().reload_current_scene()
		Global.reset_stats()
