extends Node

const DAMAGE_TEXT = preload("uid://dce1adnpbb0a7")

func damage_text(damage:float,pos:Vector3,head:bool)->void:
	var _t : DamageText = DAMAGE_TEXT.instantiate()
	add_child(_t)
	_t.start(damage,pos,head)
	
