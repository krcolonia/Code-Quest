extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@export var interact_type: String = ""

@export var required_direction: PlayerGlobalVars.FacingDirection

var interact: Callable = func():
	pass

func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self, interact_type)

func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)