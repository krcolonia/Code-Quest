extends CanvasLayer

@onready var logo = $CenterContainer/AnimatedLogo

func _ready():
	logo.hide()
	await get_tree().create_timer(1).timeout
	logo.show()
	logo.play("logoanim")

func _on_animated_logo_animation_finished():
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer(0.85).timeout
	SceneManager.change_menu(SceneManager.MENU_DICTIONARY["TITLE_SCREEN"])
