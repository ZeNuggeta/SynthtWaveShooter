extends CanvasLayer
class_name Interface

@export var available_upgrades : Array[BaseUpgrade]
@export_group("References")
@export var player : Player
@export var wave_manager : WaveManager
@export var damage_indicator: Control
@export var animation_player: AnimationPlayer 
@export var power_panel: Panel

@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var health: Label = $HUD/Health
@onready var info: RichTextLabel = $HUD/Score
@onready var xp_bar: TextureProgressBar = $HUD/XPBar
@onready var xp_label: Label = $HUD/XPBar/XPLabel

var stats_handler : StatsHandler

func _ready() -> void:
	Global.interface = self
	if player:
		stats_handler = player.stats_handler
		
		vhs.visible = vhs_toggle
		power_panel.visible = false
		damage_indicator.modulate = Color(255,255,255,0)
		
		stats_handler.health_changed.connect(_update_health)
		#wave_manager.update_info.connect(_update_info)
		
		_update_health(stats_handler.stats.health)
	
	power_panel.hide()
	update_exp()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_tab"):
		_choose_power_up_menu()

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
				await get_tree().create_timer(0.5).timeout
				wave_manager.intermission()
			-30:
				info.text = "Next Wave in %s" %enemy_count + "..."

func update_exp()->void:
	xp_label.text = "level : %s" %Global.level
	xp_bar.max_value = Global.experience_required
	xp_bar.value = Global.experience

func _choose_power_up_menu()->void:
	power_panel.visible = !power_panel.visible
	get_tree().paused = power_panel.visible
	
	if power_panel.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
