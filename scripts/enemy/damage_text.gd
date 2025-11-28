extends Node3D
class_name DamageText

var travel_distance : Vector3 = Vector3(0,2.5,0)
@onready var label_3d: Label3D = $Label3D


func start(damage:float,pos:Vector3,head:bool)->void:
	label_3d.text = str(damage)
	if head:
		label_3d.modulate = Color.YELLOW
	else:
		label_3d.modulate = Color.WHITE
	
	global_position = pos
	travel_distance += position
	#travel_distance.y *= randf_range(0.5,2.0)
	#travel_distance.x *= randf_range(-2.0,2.0)
	#travel_distance.z *= randf_range(-2.0,2.0)
	
	var duration : float = randf_range(0.75,1.25)
	
	var tween : Tween = create_tween().set_parallel(true)
	
	tween.tween_property(self,"global_position",travel_distance,duration)
	
	
	tween.chain().tween_callback(self.queue_free)
	
