extends BaseNPC

func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)

	PlayerGlobalVars.set_player_movement(true)