extends BaseNPC



func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)
	# ? If Seraphius' Printing lesson dialogue is not finished
	if !SaveGameManager.get_progress("seraphius", "lesson_printing", "dialogue"):
		Dialogic.start("Seraphius_BeforeLesson")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return
	
	# ? If Seraphius Printing lesson item 1 is not yet done
	if !SaveGameManager.get_progress("seraphius", "lesson_printing", "item1"):
		Dialogic.start("Seraphius_PrintingLessonNotDone")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

	# ? If Seraphius' Printing lesson item 1 is done
	if SaveGameManager.get_progress("seraphius", "lesson_printing", "item1") && SaveGameManager.get_npc_active("seraphius"):
		Dialogic.start("Seraphius_PrintingLessonCheck")
		await Dialogic.timeline_ended

		SaveGameManager.set_progress("seraphius", "lesson_printing", "done", true)
		SaveGameManager.set_npc_active("seraphius", false)
		SaveGameManager.set_npc_active("thalvin", true)
		SaveGameManager.write_save_details()
		PlayerGlobalVars.set_player_movement(true)
		return
	
	if !SaveGameManager.get_npc_active("seraphius") && SaveGameManager.get_npc_active("thalvin"):
		Dialogic.start("Seraphius_GoToThalvin")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return