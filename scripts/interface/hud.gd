extends Control

@onready var animation_player: AnimationPlayer = $DamageIndicator/AnimationPlayer

func _ready() -> void:
	update_exp()

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
