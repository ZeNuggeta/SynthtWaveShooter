extends Area3D
class_name HurtBox

signal hurt(hitbox:HitBox)
signal took_damage(damage:float)

func hurted(area3d:Area3D)->void:
	if area3d is not HitBox:return
	hurt.emit(area3d)

func take_damage(damage:float)->void:
	took_damage.emit(damage)
