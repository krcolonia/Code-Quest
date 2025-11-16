extends Node2D

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	SceneManager.call_deferred("change_stage", SceneManager.LEVEL1_HOME, 1096, 232, "UP")