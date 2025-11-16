extends BaseNPC

func _ready() -> void:
	super()
	Dialogic.text_signal.connect(_on_text_signal)

func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)

	if SaveGameManager.get_progress("namdal", "tutorial", "active"):
		#region # ? Introduction dialogue
		Dialogic.start("Namdal_Intro")
		await Dialogic.timeline_ended
		SaveGameManager.set_progress("namdal", "tutorial", "intro", true)
		#endregion
		start_tutorial(false)
		SaveGameManager.set_progress("namdal", "tutorial", "case_ui", true)
		SaveGameManager.set_progress("namdal", "tutorial", "active", false)
		SaveGameManager.set_progress("namdal", "tutorial", "done", true)
		SaveGameManager.set_progress("namdal", "id_seal", "active", true)
		SaveGameManager.write_save_details()
		PlayerGlobalVars.set_player_movement(true)
		return
	
	if !SaveGameManager.get_progress("namdal", "id_seal", "done"):
		Dialogic.start("Namdal_NoSealYet")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return
	else:
		print('oogabooga debug text here')
		Dialogic.start("Namdal_SealCheck")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

func start_tutorial(is_replay: bool) -> void:
	#region # ? Code UI Tutorial
	if !is_replay:
		Dialogic.start("Namdal_TutCode")
	else:
		Dialogic.start("Replay_TutCode")

	get_tree().call_group("ui", "show_code_ui")
	await Dialogic.timeline_ended
	SaveGameManager.set_progress("namdal", "tutorial", "code_ui", true)
	#endregion

	#region # ? Instructions and Test Case UI Tutorial
	if !is_replay:
		Dialogic.start("Namdal_TutCase")
	else:
		Dialogic.start("Replay_TutCase")

	get_tree().call_group("coding", "show_instructions_panel")
	await Dialogic.timeline_ended
	get_tree().call_group("coding", "hide_instructions_panel")
	get_tree().call_group("ui", "close_code_ui")
	#endregion

func _on_text_signal(argument: String) -> void:
	match argument:
		"replay_tut":
			await Dialogic.timeline_ended
			start_tutorial(true)
			await Dialogic.timeline_ended
			PlayerGlobalVars.set_player_movement(true)