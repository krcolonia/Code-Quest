extends InteractionArea

@export var face_direction: PlayerGlobalVars.FacingDirection
var is_facing: bool = false
var player_body: Node2D
	

func _on_body_entered(_body: Node2D) -> void:
	super(_body)


func _on_body_exited(_body: Node2D) -> void:
	super(_body)
