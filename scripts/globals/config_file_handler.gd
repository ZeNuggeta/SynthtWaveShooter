extends Node

var config : ConfigFile = ConfigFile.new()

const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("audio","user",1.0)
		config.set_value("audio","music",1.0)
		config.set_value("audio","sfx",1.0)
		
		config.set_value("control","mouse_sens",5.0)
		
		config.set_value("video","vhs",true)
		config.set_value("video","fullscreen",true)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)


func save_audio_setting(key:String,value:Variant)->void:
	config.set_value("audio",key,value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_setting()->Dictionary:
	var audio_settings : Dictionary = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio",key)
	return audio_settings
		

func save_control_setting(key:String,value:Variant)->void:
	config.set_value("control",key,value)
	config.save(SETTINGS_FILE_PATH)

func load_control_setting()->Dictionary:
	var control_settings : Dictionary = {}
	for key in config.get_section_keys("control"):
		control_settings[key] = config.get_value("control",key)
	return control_settings
		

func save_video_setting(key:String,value:Variant)->void:
	config.set_value("video",key,value)
	config.save(SETTINGS_FILE_PATH)

func load_video_setting()->Dictionary:
	var video_settings : Dictionary = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video",key)
	return video_settings
		
