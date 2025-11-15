extends Area2D

# TODO: Implement the animations and cutscene when ALL levels are done

@onready var anim_player = $Mother_Movement

var times_passed = 0

func _on_body_entered(body:Node2D) -> void:
	if SaveGameManager.get_progress("mother", "intro", "done"):
		return

	if body.name == "Player":
		PlayerGlobalVars.set_player_movement(false)

		SaveGameManager.set_npc_active("mother", false)

		#region # ? Dialogue that calls user before they exit
		Dialogic.start("Mother_ExitHouse")
		await Dialogic.timeline_ended
		anim_player.play("Mom_Before-Exit")
		get_tree().call_group("player", "turn_player", "UP")
		#endregion

		await anim_player.animation_finished

		#region # ? Dialogue before the player exits (Mother gives players the Journal)
		Dialogic.start("Mother_ExitTalk")
		await Dialogic.timeline_ended

		anim_player.play("Mom_After-Exit")
		await anim_player.animation_finished

		SaveGameManager.set_progress("mother", "intro", "done", true)
		SaveGameManager.set_progress("mother", "intro", "active", false)
		SaveGameManager.set_progress("namdal", "tutorial", "active", true)
		SaveGameManager.set_npc_active("namdal", true)
		#endregion

		
		SaveGameManager.write_save_details()
		PlayerGlobalVars.set_player_movement(true)