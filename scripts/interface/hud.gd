extends Control

@onready var animation_player: AnimationPlayer = $DamageIndicator/AnimationPlayer
@onready var info: RichTextLabel = $Info
@onready var tab_label: Label = $TabLabel

func _ready() -> void:
	update_exp()
	tab_label.modulate = Color("ffffff00")
	Global.leveled_up.connect(remind)

func update_info(stats:String,rainbow:bool=false) -> void:
	var rainbow_text : String = "[rainbow]" if rainbow else ""
	info.text = "[wave amp=20 freq =15]" + rainbow_text + stats 

func update_health(value:float,max_value:float,look_at:Node3D=null) -> void:
	%HealthBar.max_value = max_value
	%HealthBar.value = value
	if look_at:
		%DamageIndicator.rotation = -look_at.rotation.y
		animation_player.play("fade_out")

func update_ammo(value:int,max_value:int) -> void:
	%AmmoLabel.text = "Ammo : %s/%s" %[value,max_value]

func update_exp()->void:
	%XPLabel.text = "level : %s" %Global.level
	%XPBar.max_value = Global.experience_required
	%XPBar.value = Global.experience

func remind()->void:
	tab_label.modulate = Color.WHITE
	await get_tree().create_timer(1.5).timeout
	var tween : Tween = create_tween()
	tween.tween_property(tab_label,"modulate",Color("ffffff00"),1.5)
