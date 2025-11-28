extends HSlider

enum BUS {USER=2,SFX,MUSIC}


@export var bus : BUS = BUS.USER

func _ready() -> void:
	value_changed.connect(_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus))


func _value_changed(volume:float)->void:
	var db : float = linear_to_db(volume)
	AudioServer.set_bus_volume_db(bus,db)
