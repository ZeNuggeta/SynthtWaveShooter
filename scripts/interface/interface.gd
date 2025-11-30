extends Control
class_name Interface


@export var available_upgrades : Array[BaseUpgrade]
@export_group("References")
@export var wave_manager : WaveManager
@export var player : Player
@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var blur: ColorRect = $VFX/Blur
@onready var hud: Control = $HUD
@onready var weapon_panel: WeaponPanel = $WeaponPanel
@onready var power_panel: Panel = $PowerPanel
@onready var pause: Control = $Pause

var weapon_controller : WeaponController
var stats_handler : StatsHandler

var in_up : bool = false

func _ready() -> void:
	stats_handler = player.stats_handler
	weapon_controller = player.weapon_controller
	weapon_panel.weapon_controller = weapon_controller
	
	vhs.visible = vhs_toggle
	blur.hide()
	
	stats_handler.health_changed.connect(hud.update_health)
	wave_manager.update_info.connect(hud.update_info)
	weapon_controller.update_ammo.connect(hud.update_ammo)
	
	hud.update_health(stats_handler.stats.health,stats_handler.stats.max_health)
	hud.update_ammo(weapon_controller.ammo,weapon_controller.max_ammo)
	
	Global.update_xp.connect(hud.update_exp)
	Global.update_powerups.connect(power_panel.update_power_ups)
	
	power_panel.set_available(available_upgrades)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_tab") and !pause.visible or (event.is_action_pressed("pause") and in_up) :
		_choose_power_up_menu()
		weapon_panel.update_next_weapon()
	elif event.is_action_pressed("pause") and !in_up:
		pause.pause()

func _choose_power_up_menu()->void:
	in_up = !in_up
	power_panel.visible = in_up
	get_tree().paused = in_up
	power_panel.update_power_ups()
	blur.visible = in_up
	AudioServer.set_bus_effect_enabled(1,0,in_up)
	
	if in_up:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
