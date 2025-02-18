extends Node2D

@onready var area = $Area2D
@onready var coll = $StaticBody2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	coll.set_collision_layer_value(2, false)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_movement(false)
		if SaveGameManager.get_npc_active("seraphius"):
			coll.set_collision_layer_value(2, true)
			Dialogic.start("Thalvin_LessonBlocker")
			await Dialogic.timeline_ended
			PlayerGlobalVars.set_player_movement(true)
			return
		
		PlayerGlobalVars.set_player_movement(true)