extends BaseNPC



func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)
	if !SaveGameManager.get_progress("seraphius", "lesson_printing", "dialogue"):
		Dialogic.start("Seraphius_BeforeLesson")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return
	
	if !SaveGameManager.get_progress("seraphius", "lesson_printing", "item1"):
		Dialogic.start("Seraphius_PrintingLessonNotDone")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

	if SaveGameManager.get_progress("seraphius", "lesson_printing", "item1"):
		Dialogic.start("Seraphius_PrintingLessonCheck")
		await Dialogic.timeline_ended

		SaveGameManager.set_progress("seraphius", "lesson_printing", "done", true)
		SaveGameManager.write_save_details()
		PlayerGlobalVars.set_player_movement(true)
		return