extends Node2D

@onready var area = $Area2D
@onready var coll = $StaticBody2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	coll.set_collision_layer_value(2, true)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if !SaveGameManager.get_progress("guards", "lead_user_academe", "done"):
			coll.set_collision_layer_value(2, true)
			PlayerGlobalVars.set_player_movement(false)

			Dialogic.start("Guard_LeadUserAcademe")
			await Dialogic.timeline_ended

			SaveGameManager.set_progress("guards", "lead_user_academe", "done", true)
			SaveGameManager.set_progress("seraphius", "intro", "active", true)
			coll.set_collision_layer_value(2, false)
			SaveGameManager.write_save_details()
			PlayerGlobalVars.set_player_movement(true)
			return
		
		if SaveGameManager.get_progress("seraphius", "intro", "done"):
			coll.set_collision_layer_value(2, true)
			PlayerGlobalVars.set_player_movement(false)

			Dialogic.start("Seraphius_IntroLeave")
			await Dialogic.timeline_ended

			PlayerGlobalVars.set_player_movement(true)
			return

		coll.set_collision_layer_value(2, false)
		

