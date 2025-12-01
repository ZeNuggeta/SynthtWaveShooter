extends HSlider

enum BUS {USER=2,SFX,MUSIC}


@export var bus : BUS = BUS.USER

func _ready() -> void:
	
	var audio_setting : Dictionary = ConfigFileHandler.load_audio_setting()
	var db : float
	match bus:
		BUS.USER:
			db = audio_setting.user
		BUS.SFX:
			db = audio_setting.sfx
		BUS.MUSIC:
			db = audio_setting.music
	
	
	
	AudioServer.set_bus_volume_db(bus,linear_to_db(db))
	value = db
	
	value_changed.connect(_value_changed)


func _value_changed(volume:float)->void:
	var db : float = linear_to_db(volume)
	AudioServer.set_bus_volume_db(bus,db)
	var type : String = ""
	match bus:
		BUS.USER:
			type = "user"
		BUS.SFX:
			type = "sfx"
		BUS.MUSIC:
			type = "music"
	ConfigFileHandler.save_audio_setting(type,volume)
	
