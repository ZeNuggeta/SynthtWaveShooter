extends PlayerState


func _on_air_born_state_physics_processing(_delta: float) -> void:
	if player_controller.is_on_floor():
		if player_controller.check_fall_speed():
			player_controller.camera_effect.add_fall_kick(2.0)
		player_controller.state_chart.send_event("on_ground")
		
	player_controller.curren_fall_velocity = player_controller.velocity.y
