extends Control

func _ready() -> void:
	for i in %Buttons.get_children():
		print(i)

func _on_start_pressed() -> void:
	LoadingScreen.start_loading('uid://dm3gqheyx1prf')

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
