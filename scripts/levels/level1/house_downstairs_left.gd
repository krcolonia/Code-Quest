extends Area2D


func _on_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		SceneManager.call_deferred("change_location", 264, -104, "DOWN")
