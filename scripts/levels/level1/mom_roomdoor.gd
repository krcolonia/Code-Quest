extends Node2D

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	PlayerGlobalVars.can_move = false
	Dialogic.start("Mother_RoomDoor")

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	PlayerGlobalVars.can_move = true
	pass
