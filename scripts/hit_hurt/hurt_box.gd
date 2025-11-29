extends Area3D
class_name HurtBox

signal hurt(hitbox:HitBox)
signal took_damage(damage:float,head:bool)

@export var head_shot_multiplier : float = 1.0

func hurted(area3d:Area3D)->void:
	hurt.emit(area3d)

func take_damage(damage:float)->void:
	took_damage.emit(damage * head_shot_multiplier,(head_shot_multiplier>1))
