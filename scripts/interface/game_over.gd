extends Control

@onready var score_label: Label = $Panel/VBoxContainer/ScoreLabel
@onready var high_label: Label = $Panel/VBoxContainer/HighLabel

func _ready() -> void:
	game_over()

func game_over() -> void:
	if Global.kills > Saveload.contents_to_save.kills:
		Saveload.contents_to_save.kills = Global.kills
		Saveload._save()
		high_label.text = "Highscore: %d" %[Saveload.contents_to_save.kills]
		score_label.text = "New highscore: %d" %[Global.kills]
	else:
		high_label.text = "Highscore: %d" %[Saveload.contents_to_save.kills]
		score_label.text = "Score : %d" %[Global.kills]




func _on_return_button_pressed() -> void:
	LoadingScreen.start_loading('uid://dlh5mphjdwpjg')
