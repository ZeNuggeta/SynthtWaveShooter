extends Resource
class_name BaseUpgrade

enum TYPES {HEALTH,REGEN,DAMAGE,FIRERATE,QUANTITY}

@export var upgrade_name : String
@export var icon : Texture2D
@export var upgrade_type : TYPES = TYPES.HEALTH
@export var amount : float = 0.02
@export var max_ups : float = amount * 5
