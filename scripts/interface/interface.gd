extends CanvasLayer
class_name Interface

@export var available_upgrades : Array[BaseUpgrade]
@export_group("References")
@export var player : Player
@export var wave_manager : WaveManager
@export var damage_indicator: Control
@export var animation_player: AnimationPlayer 
@export var panel_container : Control
@export var power_panel: Panel

@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var health: Label = $HUD/Health
@onready var info: RichTextLabel = $HUD/Score
@onready var block: Control = $Block

var stats_handler : StatsHandler

func _ready() -> void:
	if player:
		stats_handler = player.stats_handler
		
		vhs.visible = vhs_toggle
		power_panel.visible = false
		damage_indicator.modulate = Color(255,255,255,0)
		
		stats_handler.health_changed.connect(_update_health)
		wave_manager.update_info.connect(_update_info)
		
		_update_health(stats_handler.stats.health)
		
	for p in panel_container.get_children():
		p.my_upgrade.connect(upgrade)
	power_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shuffle_upgrades()
	block.hide()
	
	



func upgrade(up:BaseUpgrade)-> void:
	if stats_handler:
		stats_handler.apply_stat_upgrade(up)
	_choose_power_up_menu(false)
	wave_manager.intermission()

func _update_health(value:float,look_at:Node3D=null) -> void:
	health.text = "Health : %s" %value
	if look_at:
		damage_indicator.rotation = -look_at.rotation.y
		animation_player.play("fade_out")

func _update_info(wave:int,enemy_count:int=0) -> void:
	if wave >= 0:
		info.text = "[wave amp=20 freq =15] wave : %s" %wave + " score : %s |" %Global.points + " enemys left : %s [/wave]" %enemy_count
	else:
		match wave:
			-10:
				info.text = "Well Done!!! Finished all waves !!"
				
			-20:
				info.text = "[rainbow] Wave Finished"
				_choose_power_up_menu(true)
				
			-30:
				info.text = "Next Wave in %s" %enemy_count + "..."


func _choose_power_up_menu(value:bool)->void:
	block.show()
	power_panel.visible = value
	get_tree().paused = value
	
	if value:
		shuffle_upgrades()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		await get_tree().create_timer(0.5).timeout
		power_panel.mouse_filter = Control.MOUSE_FILTER_STOP
		block.hide()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		block.hide()
	


func shuffle_upgrades()->void:
	for p : UpgradeSlot in panel_container.get_children():
		p.upgrade = available_upgrades.pick_random()
		p.update_card()
