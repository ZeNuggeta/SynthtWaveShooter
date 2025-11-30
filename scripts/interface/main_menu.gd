extends Control

@onready var settings: Control = $Settings
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	Saveload._load()
	Global.kills = Saveload.contents_to_save.kills
	if Saveload.contents_to_save.kills > 0:
		score_label.text = "Highscore : %d" %Saveload.contents_to_save.kills

func _on_start_pressed() -> void:
	Global.reset_stats()
	LoadingScreen.start_loading('uid://dm3gqheyx1prf')

func _on_options_pressed() -> void:
	settings.show()


func _on_quit_pressed() -> void:
	get_tree().quit()
