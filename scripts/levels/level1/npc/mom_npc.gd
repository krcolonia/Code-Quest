extends BaseNPC

func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)

	if !SaveGameManager.get_progress("mother", "intro", "done"):
		# region # ? Before Exiting House
		Dialogic.start("Mother_Interact")
		await Dialogic.timeline_ended
		SaveGameManager.set_progress("mother", "intro", "done", true)
		SaveGameManager.set_progress("mother", "intro", "active", false)
		SaveGameManager.set_npc_active("mother", false)
		SaveGameManager.set_progress("namdal", "tutorial", "active", true)
		SaveGameManager.set_npc_active("namdal", true)
		SaveGameManager.write_save_details()
		PlayerGlobalVars.set_player_movement(true)
		return
		# endregion
	
	#region # ? Returning To House
	Dialogic.start("Mother_InteractAfterExit")
	await Dialogic.timeline_ended
	PlayerGlobalVars.set_player_movement(true)
	#endregion