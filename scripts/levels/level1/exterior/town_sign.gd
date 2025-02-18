extends Node2D

@onready var interaction_area = $InteractionArea

func _ready() -> void:
	interaction_area.interact_type = "item"
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)
	Dialogic.start("Town_SignGuide")
	await Dialogic.timeline_ended
	PlayerGlobalVars.set_player_movement(true)
