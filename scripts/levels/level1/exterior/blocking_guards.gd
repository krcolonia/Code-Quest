extends Node2D

@onready var anim = $AnimationPlayer
@onready var area = $Area2D
@onready var coll = $StaticBody2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

	if !SaveGameManager.get_progress("namdal", "id_seal", "done"):
		coll.set_collision_layer_value(2, true)
		anim.play("RESET")

	if SaveGameManager.get_progress("guards", "unblock_way", "done"):
		coll.set_collision_layer_value(2, false)
		anim.play("Guard_SetUnblock")



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":	
		if !SaveGameManager.get_progress("namdal", "id_seal", "done"):
			PlayerGlobalVars.set_player_movement(false)
			coll.set_collision_layer_value(2, true)
			Dialogic.start("Guard_NoIdentifySeal")
			await Dialogic.timeline_ended
			PlayerGlobalVars.set_player_movement(true)
			return
		
		if !SaveGameManager.get_progress("guards", "unblock_way", "done"):
			PlayerGlobalVars.set_player_movement(false)
			coll.set_collision_layer_value(2, true)

			Dialogic.start("Guard_HasIdentifySeal")
			await Dialogic.timeline_ended

			anim.play("Guard_UnblockWay")
			await anim.animation_finished

			SaveGameManager.set_progress("guards", "unblock_way", "done", true)
			SaveGameManager.write_save_details()
			coll.set_collision_layer_value(2, false)
			PlayerGlobalVars.set_player_movement(true)
			return
			
		
