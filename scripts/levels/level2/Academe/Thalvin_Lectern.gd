extends ProgramObject

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D

var demo_scripts: Dictionary = {
	"demo1" : {

		"code1": "# Insert all commands to be ran inside the main method

def main():
	var",
		"code2": "# Insert all commands to be ran inside the main method

def main():
	var = \"Hello!\"",

		"code3": "# Insert all commands to be ran inside the main method

def main():
	var = \"Hello!\"
	print(var)",

		"output": "Hello!",
	},

}

var vars_to_check

func _ready() -> void:
	test_case = {
		"test1": {
			"expected_output": "Amulet of Wisdom!"
		},
		"test2": {
			"expected_output": "3000"
		},
		"test3": {
			"expected_output": "true"
		}
	}

	vars_to_check = "print(relic_name)
	print(relic_price)
	print(original_relic
	
	def main():
		"

	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.text_signal.connect(_on_text_signal)

	interaction_area.interact_type = "item"
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	if !SaveGameManager.get_progress("thalvin", "lesson_datatypes", "done"):
		PlayerGlobalVars.set_player_movement(false)
		Dialogic.start("Thalvin_DataTypeLesson")
		await Dialogic.timeline_ended
		PlayerGlobalVars.set_player_movement(true)
		return

func _on_dialogic_signal(argument: String) -> void:
	match argument:
		"datatypes_done":
			SaveGameManager.set_progress("thalvin", "lesson_datatypes", "dialogue", true)
			SaveGameManager.set_progress("thalvin", "lesson_datatypes", "done", true)
			SaveGameManager.set_progress("thalvin", "lesson_datatypes", "active", false)
			SaveGameManager.set_progress("thalvin", "lesson_variables", "active", true)
		"open_codeui":
			get_tree().call_group("ui", "show_code_ui")
		"thalvin_demostart":
			get_tree().call_group("coding", "set_output_text", "")
		"thalvin_activity":
			prepare_question()

func _on_text_signal(argument: String) -> void:
	match argument:
		"demo1code1":
			get_tree().call_group("coding", "set_code", demo_scripts["demo1"]["code1"])
		"demo1code2":
			get_tree().call_group("coding", "set_code", demo_scripts["demo1"]["code2"])
		"demo1code3":
			get_tree().call_group("coding", "set_code", demo_scripts["demo1"]["code3"])
		"demo1output":
			get_tree().call_group("coding", "set_output_text", demo_scripts["demo1"]["output"])