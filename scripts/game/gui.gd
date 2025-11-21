extends CanvasLayer

@export var wave_manager : WaveManager

@onready var interface: Interface = $Interface


func set_player(player : Player)->void:
	for i in get_children():
		i.player = player
	interface.wave_manager = wave_manager
	interface.setup()
