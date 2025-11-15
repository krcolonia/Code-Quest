extends ProgramObject

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D


var demo_scripts: Dictionary = {
	"demo1" : {
		"code": "def main():
	print('Hello, World!')",
		"output": "Hello, World!",
	},
	"demo2" : {
		"code": "def main():
	print('Hello, World!')
	print('Welcome to Code Quest!')",
		"output": "Hello, World!\nWelcome to Code Quest!",
	},
	"demo3" : {
		"code": "def main():
	print('Hello,\\nWorld!')",
		"output": "Hello,\nWorld!",
	},
	"demo4" : {
		"code": "def main():
	print('Elders: ' + 3)
	print('Students:', 6)",
		"output": "Elders: 3\nStudents: 6",
	}
}

func _ready() -> void:
	test_case = {
		"test1": {
			"expected_output": "Greetings, Binarius!"
		},
		"test2": {
			"expected_output": "Learning Python!"
		},
		"test3": {
			"expected_output": "Printing 3 Lines!"
		}
	}

	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_text_signal)

	interaction_area.interact_type = "item"
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:

	get_tree().call_group("coding", "set_replay_lesson", "Seraphius_ReplayLesson")

	PlayerGlobalVars.set_player_movement(false)
	if SaveGameManager.get_progress(npc_name, mission_name, mission_done):
		Dialogic.start("ProgramObject_AlreadyDone")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

	if !SaveGameManager.get_progress("seraphius", "lesson_printing", "dialogue"):
		#region # ? Lesson Dialogue
		Dialogic.start("Seraphius_PrintingLesson")
		await Dialogic.timeline_ended

		prepare_question()
		get_tree().call_group("ui", "show_code_ui")
		Dialogic.start("Seraphius_PrintingLessonDemo")

		await Dialogic.timeline_ended
		SaveGameManager.set_progress("seraphius", "lesson_printing", "dialogue", true)
		SaveGameManager.write_save_details()

		prepare_question()
		get_tree().call_group("coding", "set_dialogue", true, "Seraphius_PrintingLessonDone")
		PlayerGlobalVars.set_player_movement(true)
		#endregion
	
	if !SaveGameManager.get_progress("seraphius", "lesson_printing", "item1"):
		prepare_question()
		get_tree().call_group("coding", "set_dialogue", true, "Seraphius_PrintingLessonDone")
		get_tree().call_group("ui", "show_code_ui")

func _on_dialogic_signal(argument: String) -> void:
	match argument:
		"print_code1":
			lesson_set_code(demo_scripts["demo1"]["code"])
			lesson_set_output("")
		"print_code2":
			lesson_set_code(demo_scripts["demo2"]["code"])
			lesson_set_output("")
		"print_code3":
			lesson_set_code(demo_scripts["demo3"]["code"])
			lesson_set_output("")
		"print_code4":
			lesson_set_code(demo_scripts["demo4"]["code"])
			lesson_set_output("")

func _on_text_signal(argument: String) -> void:
	match argument:
		"print_output1":
			lesson_set_output(demo_scripts["demo1"]["output"])
		"print_output2":
			lesson_set_output(demo_scripts["demo2"]["output"])
		"print_output3":
			lesson_set_output(demo_scripts["demo3"]["output"])
		"print_output4":
			lesson_set_output(demo_scripts["demo4"]["output"])
