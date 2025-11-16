extends Node
## This is a class that is inherited by all objects that
## contain programming questions. Has instructions, checks
## if code contains inputs, and test cases for user code.
class_name ProgramObject

## This is an export variable for the instructions of the
## programming question. You should use BBCode to format
## the text within it. -krColonia
@export_multiline var instructions: String

## This is an export variable to check if the code that
## will be passed from this object will make use of the
## Python 'input()' method
@export var has_inputs: bool = false

## This is an export variable for the test cases to check
## during code execution. "test1" is already defined as a
## reference to the structuring of test cases. -krColonia
var test_case: Dictionary = {
	"test1": {
		"input_value": [],
		"expected_output": ""
	}
}

## This is an export variable for the amount of points to
## award the players once they finish an instance of a
## Program Object.
@export var points: int

## This is an export variable for the preset code of the
## current programmable object. This is for questions that
## require users to make use of specific variables.
## When using this, make sure that the variables or functions
## you type inside of this export variable contains comments
## that indicate that the variables should not be deleted,
## only modified.
@export_multiline var preset_code: String = "
def main():
	"


@export var npc_name: String
@export var mission_name: String
@export var mission_done: String

@export var dialogue_name: String

var object_done: bool = false

#region SampleCode
# ? Below is an example of a test case if you're expecting
# ? user input - krColonia

const _sample1: Dictionary = {
	"test": {
		"input_value": [],
		"expected_output": "output"
	}
}

# ? Below is an example of a test case if you're not expecting
# ? user input

const _sample2: Dictionary = {
	"test": "output"
}
#endregion

#region Test Case Preparation Functions
func prepare_displayed_cases() -> String:
	var prepared_cases: String = ""
	var prepared_output: String = ""

	for case in test_case:
		prepared_output += test_case[case].expected_output + "\n"
	
	if !has_inputs:
		return "[b]Test Cases[/b]:\n" + prepared_output

	for case in test_case:
		prepared_cases += ", ".join(test_case[case].input_value) + "\n"

	return "[b]Test Cases[/b]:\n" + prepared_cases + "\n[b]Expected Output[/b]:\n" + prepared_output

func prepare_stdin() -> Variant:
	var stdin: Variant = null

	for case in test_case:
		if stdin == null:
			stdin = test_case[case].input_value
		else:
			stdin += test_case[case].input_value
	stdin = "\n".join(stdin)

	return stdin

func prepare_outputs() -> Array:
	var output: Array = []

	for case in test_case:
		output.push_back(test_case[case].expected_output)

	return output

func prepare_question() -> void:
	get_tree().call_group("coding", "set_expected_output", prepare_outputs(), test_case.size())
	if has_inputs:
		get_tree().call_group("coding", "set_stdin", prepare_stdin())
	get_tree().call_group("coding", "set_instruct_case", instructions, prepare_displayed_cases(), has_inputs)
	get_tree().call_group("coding", "set_points", points)
	get_tree().call_group("coding", "set_progress_var", npc_name, mission_name, mission_done)
	get_tree().call_group("coding", "set_code", preset_code)
	get_tree().call_group("coding", "set_output_text", "")
#endregion

func lesson_set_code(code: String) -> void:
	get_tree().call_group("coding", "set_code", code)

func lesson_set_output(stdout: String) -> void:
	get_tree().call_group("coding", "set_output_text", stdout)