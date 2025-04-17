extends ProgramObject

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D

var demo_scripts: Dictionary = {
	"demo1" : {
		"code": "
def_main():
	print('Name:')
	print('Gender:')",
		"output": "Name:\nGender:"
	},
	"demo2": {
		"code": "
def_main():
	print('Name: Namdal')
	print('Gender: Male')",
		"output": "Name: Namdal\nGender: Male"
	},
	"demo3": {
		"code" : "
def_main():
	print('Name: %s')
	print('Gender: %s')" % [Dialogic.VAR.user_var.username, Dialogic.VAR.user_var.gender.capitalize()],
		"output" : "Name: %s\nGender: %s" % [Dialogic.VAR.user_var.username, Dialogic.VAR.user_var.gender.capitalize()],
	}
}

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	Dialogic.text_signal.connect(_on_text_signal)

	interaction_area.interact_type = "item"
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	PlayerGlobalVars.set_player_movement(false)

	if !SaveGameManager.get_progress("namdal", "tutorial", "done"):
		Dialogic.start("Namdal_LecternNotKnownYet")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

	if SaveGameManager.get_progress(npc_name, mission_name, mission_done):
		Dialogic.start("ProgramObject_AlreadyDone")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

	test_case = {
		"test1": {
			"expected_output": "Name: " + Dialogic.VAR.user_var.username
		},
		"test2": {
			"expected_output": "Gender: " + Dialogic.VAR.user_var.gender.capitalize()
		}
	}

	get_tree().call_group("ui", "show_code_ui")
	

	if !SaveGameManager.get_progress("namdal", "id_seal", "intro"):
		Dialogic.start("Namdal_IdentitySeal")
		await Dialogic.timeline_ended
		SaveGameManager.set_progress("namdal", "id_seal", "intro", true)
		SaveGameManager.set_progress("namdal", "id_seal", "done", true)
		SaveGameManager.set_progress("namdal", "id_seal", "active", false)
		SaveGameManager.set_npc_active("namdal", false)
		SaveGameManager.set_achievement("achieve1", true)
		SaveGameManager.set_npc_active("seraphius", true)
		SaveGameManager.set_points(points)
		SaveGameManager.write_save_details()
		get_tree().call_group("ui", "close_code_ui")
		PlayerGlobalVars.set_player_movement(true)
		return

func _on_text_signal(argument: String) -> void:
	match argument:
		"tut_code1":
			lesson_set_code(demo_scripts["demo1"]["code"])
			lesson_set_output("")
		"tut_output1":
			lesson_set_output(demo_scripts["demo1"]["output"])

		"tut_code2":
			lesson_set_code(demo_scripts["demo2"]["code"])
			lesson_set_output("")
		"tut_output2":
			lesson_set_output(demo_scripts["demo2"]["output"])

		"tut_code3":
			lesson_set_code(demo_scripts["demo3"]["code"])
			lesson_set_output("")
		"tut_output3":
			lesson_set_output(demo_scripts["demo3"]["output"])
 