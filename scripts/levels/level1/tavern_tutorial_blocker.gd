extends Node2D


@onready var area = $Area2D
@onready var coll = $StaticBody2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	coll.set_collision_layer_value(2, false)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		if SaveGameManager.get_progress("namdal", "tutorial", "active"):
			coll.set_collision_layer_value(2, false)
			return

		if SaveGameManager.get_progress("namdal", "id_seal", "active"):
			coll.set_collision_layer_value(2, true)
			PlayerGlobalVars.set_player_movement(false)
			Dialogic.start('Namdal_NotDone')
			await Dialogic.timeline_ended
			PlayerGlobalVars.set_player_movement(true)
			return
		else:
			coll.set_collision_layer_value(2, false)
			return
