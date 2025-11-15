extends Node2D

@onready var area = $Area2D
@onready var coll = $StaticBody2D
@onready var anim = $AnimationPlayer

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	coll.set_collision_layer_value(2, false)

	if !SaveGameManager.get_progress("seraphius", "intro", "done"):
		anim.play("RESET")
	else:
		anim.play("Seraphius_Intro_End")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if !SaveGameManager.get_progress("seraphius", "intro", "done"):
			# SaveGameManager.set_npc_active("seraphius", false)
			coll.set_collision_layer_value(2, true)
			PlayerGlobalVars.set_player_movement(false)

			Dialogic.start("Seraphius_Intro")
			await Dialogic.timeline_ended

			anim.play("Seraphius_Intro_Animation")
			await anim.animation_finished

			SaveGameManager.set_progress("seraphius", "intro", "done", true)
			SaveGameManager.set_progress("seraphius", "intro", "active", false)
			SaveGameManager.set_progress("seraphius", "lesson_printing", "active", true)
			coll.set_collision_layer_value(2, false)
			SaveGameManager.write_save_details()
			PlayerGlobalVars.set_player_movement(true)
		else:
			coll.set_collision_layer_value(2, false)
