extends BaseNPC

func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)
	Dialogic.start("Garrick_Lesson")
	await Dialogic.timeline_ended
	PlayerGlobalVars.set_player_movement(true)