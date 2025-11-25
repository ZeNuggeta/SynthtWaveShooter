extends Control
class_name Interface


@export var available_upgrades : Array[BaseUpgrade]
@export_group("References")
@export var wave_manager : WaveManager
@export var player : Player
@export var damage_indicator: Control
@export var animation_player: AnimationPlayer 
@export var power_panel: Panel
@export var power_up_container: GridContainer

@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var info: RichTextLabel = $HUD/Score
@onready var description_label: Label = $PowerPanel/MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel
@onready var hud: Control = $HUD
@onready var weapon_panel: WeaponPanel = $WeaponPanel
@onready var pause: Control = $Pause

var weapon_controller : WeaponController
var stats_handler : StatsHandler

var in_up : bool = false

func _ready() -> void:
	stats_handler = player.stats_handler
	weapon_controller = player.weapon_controller
	weapon_panel.weapon_controller = weapon_controller
	
	vhs.visible = vhs_toggle
	
	stats_handler.health_changed.connect(hud.update_health)
	wave_manager.update_info.connect(_update_info)
	weapon_controller.update_ammo.connect(hud.update_ammo)
	
	hud.update_health(stats_handler.stats.health,stats_handler.stats.max_health)
	hud.update_ammo(weapon_controller.ammo,weapon_controller.max_ammo)
	
	
	Global.update_xp.connect(hud.update_exp)
	Global.update_powerups.connect(_update_power_ups)
	
	for p : UpgradePanel in power_up_container.get_children():
		p.upgrade = available_upgrades[p.get_index()]
		p.update_card()
	
	power_panel.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_tab") or (event.is_action_pressed("pause") and in_up):
		_choose_power_up_menu()
		weapon_panel.update_next_weapon()
	elif event.is_action_pressed("pause") and !in_up:
		pause.pause()

func _update_info(stats:String,rainbow:bool=false) -> void:
	var rainbow_text : String = "[rainbow]" if rainbow else ""
	info.text = "[wave amp=20 freq =15]" + rainbow_text + stats 

func _choose_power_up_menu()->void:
	in_up = !in_up
	power_panel.visible = in_up
	get_tree().paused = in_up
	_update_power_ups()
	if in_up:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _update_power_ups()->void:
	var to_say : String = "Skill points : %d\nLevel : %d\n\nHealth : x%.2f\nRegen : x%.2f\nDamage: x%.2f\nFirerate : x%.2f\nQuantity : +%d\n" 
	var stats : Dictionary[String,float] = Global.stats
	description_label.text = to_say % [Global.skill_points,Global.level,stats["Health"],stats["Regen"],stats["Damage"],stats["FireRate"],stats["Quantity"]]
