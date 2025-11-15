extends BaseNPC

func _process(_delta: float) -> void:
	if !SaveGameManager.get_progress("seraphius", "intro", "active"):
		important_indicator.hide()

func _on_interact() -> void:
	if !SaveGameManager.get_progress("seraphius", "intro", "done"):
		PlayerGlobalVars.set_player_movement(false)

		Dialogic.start("Seraphius_Intro")
		await Dialogic.timeline_ended

		SaveGameManager.set_progress("seraphius", "intro", "done", true)
		SaveGameManager.set_progress("seraphius", "intro", "active", false)
		SaveGameManager.set_progress("seraphius", "lesson_printing", "active", true)
		PlayerGlobalVars.set_player_movement(true)
