extends Control


func _ready() -> void:
	if Global.kills > Saveload.contents_to_save.kills:
		Saveload.contents_to_save.kills = Global.kills
		Saveload._save()
		$Label.text = "New highscore: %d" %[Global.kills]
	else:
		$Label.text = "Highscore : %d" %[Global.kills]
