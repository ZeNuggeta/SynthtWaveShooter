extends Node

@export var dev_mode : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if !dev_mode:return
	if event.is_action_pressed("dev_exit"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
