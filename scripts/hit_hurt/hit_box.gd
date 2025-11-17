extends Area3D
class_name HitBox


@export var damage : float = 10

func _ready() -> void:
	area_entered.connect(_on_area_enterd)

func _on_area_enterd(area3d:Area3D)->void:
	if area3d is not HurtBox:return
	area3d.hurted(self)
