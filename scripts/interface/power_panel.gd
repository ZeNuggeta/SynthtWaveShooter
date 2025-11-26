extends Panel

@onready var power_up_container: GridContainer = $MarginContainer/HBoxContainer/PowerUpContainer
@onready var description_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel

func _ready() -> void:
	hide()


func set_available(available_upgrades:Array[BaseUpgrade])->void:
	for p : UpgradePanel in power_up_container.get_children():
		p.upgrade = available_upgrades[p.get_index()]
		p.update_card()

func update_power_ups()->void:
	var to_say : String = "Skill points : %d\nLevel : %d\n\nHealth : x%.2f\nRegen : x%.2f\nDamage: x%.2f\nFirerate : x%.2f\nQuantity : +%d\n" 
	var stats : Dictionary[String,float] = Global.stats
	description_label.text = to_say % [Global.skill_points,Global.level,stats["Health"],stats["Regen"],stats["Damage"],stats["FireRate"],stats["Quantity"]]
