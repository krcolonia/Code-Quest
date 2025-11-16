extends Area2D

@onready var seraphius_anim = $SeraphiusAnimation
@onready var thalvin_anim = $ThalvinAnimation
@onready var lorem_anim = $LoremAnimation

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

	if SaveGameManager.get_npc_active("seraphius"):
		seraphius_anim.play("seraphius_active")
	else:
		seraphius_anim.play("RESET")
	
	if SaveGameManager.get_npc_active("thalvin"):
		thalvin_anim.play("thalvin_active")
	else:
		thalvin_anim.play("RESET")
	


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if SaveGameManager.get_progress("seraphius", "lesson_printing", "done") && !SaveGameManager.get_npc_active("thalvin"):
			PlayerGlobalVars.set_player_movement(false)
			await get_tree().create_timer(0.1).timeout
			get_tree().call_group("player", "turn_player", "RIGHT")
			Dialogic.start("Seraphius_Outro")
			await Dialogic.timeline_ended
			SaveGameManager.set_progress("seraphius", "lesson_printing", "active", false)
			SaveGameManager.set_npc_active("seraphius", false)
			SaveGameManager.set_npc_active("thalvin", true)
			SaveGameManager.set_progress("thalvin", "lesson_datatypes", "active", true)
			SaveGameManager.write_save_details()
			seraphius_anim.play("seraphius_exit")
			await seraphius_anim.animation_finished
			seraphius_anim.play("RESET")
			thalvin_anim.play("thalvin_enter")
			await thalvin_anim.animation_finished
			PlayerGlobalVars.set_player_movement(true)
