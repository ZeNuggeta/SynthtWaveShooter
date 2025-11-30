extends Node

const save_loc : String = "user://SaveFile.json"

var contents_to_save : Dictionary = {
	"kills" : 0
}

func _ready() -> void:
	_load()

func _save()->void:
	var file : FileAccess= FileAccess.open(save_loc,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load()->void:
	if FileAccess.file_exists(save_loc):
		var file : FileAccess= FileAccess.open(save_loc,FileAccess.READ)
		var data : Variant = file.get_var()
		file.close()
		
		var save_data : Variant = data.duplicate()
		contents_to_save.kills = save_data.kills
		
		
