extends CanvasLayer
class_name Interface

@export var available_upgrades : Array[BaseUpgrade]
@export_group("References")
@export var player : Player
@export var wave_manager : WaveManager
@export var damage_indicator: Control
@export var animation_player: AnimationPlayer 
@export var power_panel: Panel
@export var power_up_container: GridContainer

@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var health_bar: ProgressBar = $HUD/HealthBar
@onready var info: RichTextLabel = $HUD/Score
@onready var xp_bar: TextureProgressBar = $HUD/XPBar
@onready var xp_label: Label = $HUD/XPBar/XPLabel
@onready var ammo_label: Label = $HUD/AmmoLabel
@onready var description_label: Label = $PowerPanel/MarginContainer/HBoxContainer/DescriptionLabel

var weapon_controller : WeaponController
var stats_handler : StatsHandler

func _ready() -> void:
	if player:
		stats_handler = player.stats_handler
		weapon_controller = player.weapon_controller
		
		vhs.visible = vhs_toggle
		power_panel.visible = false
		damage_indicator.modulate = Color(255,255,255,0)
		
		stats_handler.health_changed.connect(_update_health)
		wave_manager.update_info.connect(_update_info)
		weapon_controller.update_ammo.connect(_update_ammo)
		
		_update_health(stats_handler.stats.health,stats_handler.stats.max_health)
		_update_ammo(weapon_controller.ammo,weapon_controller.max_ammo)
	
	Global.update_xp.connect(_update_exp)
	Global.update_powerups.connect(_update_power_ups)
	_update_exp()
	
	for p : UpgradePanel in power_up_container.get_children():
		p.upgrade = available_upgrades[p.get_index()]
		p.update_card()

	power_panel.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_tab"):
		_choose_power_up_menu()

func _update_health(value:float,max_value:float,look_at:Node3D=null) -> void:
	health_bar.max_value = max_value
	health_bar.value = value
	if look_at:
		damage_indicator.rotation = -look_at.rotation.y
		animation_player.play("fade_out")

func _update_ammo(value:int,max_value:int) -> void:
	ammo_label.text = "Ammo : %s/%s" %[value,max_value]

func _update_info(stats:String,rainbow:bool=false) -> void:
	var rainbow_text : String = "[rainbow]" if rainbow else ""
	info.text = "[wave amp=20 freq =15]" + rainbow_text + stats 

func _update_exp()->void:
	xp_label.text = "level : %s" %Global.level
	xp_bar.max_value = Global.experience_required
	xp_bar.value = Global.experience

func _choose_power_up_menu()->void:
	_update_power_ups()
	power_panel.visible = !power_panel.visible
	get_tree().paused = power_panel.visible
	
	if power_panel.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _update_power_ups()->void:
	var to_say : String = "Skill points : %s\nLevel : %s\nHealth : x%s\nRegen : x%s\nDamage: x%s\nFirerate : x%s\nQuantity : +%s\n" 
	var stats : Dictionary[String,float] = Global.stats
	description_label.text = to_say % [Global.skill_points,Global.level,stats["Health"],stats["Regen"],stats["Damage"],stats["FireRate"],stats["Quantity"]]
