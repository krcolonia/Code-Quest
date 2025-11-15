extends CanvasLayer

# FIXME -> Always check https://github.com/Jaagrav/CodeX-API if the CodeX API is Healthy/Online, if not, make use of the JDoodle API
# FIXME -> Take note that the JDoodle API account I used only has the free plan and a total of 220 credits per day. It resetes every 8am in the Philippines
# FIXME -> If ever we find the time (and money) we'll pay for a better subscription plan that allows for more credits and usage of the compiler API -krColonia

@onready var code: CodeEdit = $CodingPanel/MarginContainer/VBoxContainer/CodeEdit
@onready var console: RichTextLabel = $CodingPanel/MarginContainer/VBoxContainer/OutputPanel/MarginContainer/Output
@onready var http: HTTPRequest = $HTTPRequest
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var view_instruction_btn: Button = $VBoxContainer/ShowPanel/MarginContainer/ViewInstructions
@onready var instructions_label: RichTextLabel = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/QuestionPanel/MarginContainer/VBoxContainer/Label
@onready var instructions_text: RichTextLabel = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/QuestionPanel/MarginContainer/VBoxContainer/RichTextLabel
@onready var testcase_text: RichTextLabel = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/TestCasePanel/MarginContainer/RichTextLabel

@onready var replay_button: Button = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/ReplayLesson

var is_showing_instructions: bool

var replay_lesson: String = ""

var has_stdin: bool = false
var expected_output: Array
var expected_output_count: int
var stdin: Variant
var points_to_give: int

var output_is_correct: bool


var has_dialogue_after: bool = false
var dialogue_to_play: String = ""

var npc_name: String
var mission_name: String
var mission_done: String

func _ready() -> void:
	http.request_completed.connect(_on_exec_script_request_completed)
	is_showing_instructions = false

	replay_button.button_up.connect(self._on_replay_button_up)

func _on_replay_button_up() -> void:
	Dialogic.start(replay_lesson)

func set_font() -> void:
	code.add_theme_font_size_override("font_size", Settings.codefont_size)
	console.add_theme_font_size_override("normal_font_size", Settings.codefont_size)

	instructions_label.add_theme_font_size_override("normal_font_size", Settings.codefont_size + 8.0)
	instructions_label.add_theme_font_size_override("mono_font_size", Settings.codefont_size + 8.0)
	instructions_label.add_theme_font_size_override("bold_font_size", Settings.codefont_size + 8.0)
	instructions_label.add_theme_font_size_override("italics_font_size", Settings.codefont_size + 8.0)
	instructions_label.add_theme_font_size_override("bold_italics_font_size", Settings.codefont_size + 8.0)

	instructions_text.add_theme_font_size_override("normal_font_size", Settings.codefont_size + 8.0)
	instructions_text.add_theme_font_size_override("mono_font_size", Settings.codefont_size + 8.0)
	instructions_text.add_theme_font_size_override("bold_font_size", Settings.codefont_size + 8.0)
	instructions_text.add_theme_font_size_override("italics_font_size", Settings.codefont_size + 8.0)
	instructions_text.add_theme_font_size_override("bold_italics_font_size", Settings.codefont_size + 8.0)

	testcase_text.add_theme_font_size_override("normal_font_size", Settings.codefont_size + 8.0)
	testcase_text.add_theme_font_size_override("mono_font_size", Settings.codefont_size + 8.0)
	testcase_text.add_theme_font_size_override("bold_font_size", Settings.codefont_size + 8.0)
	testcase_text.add_theme_font_size_override("italics_font_size", Settings.codefont_size + 8.0)
	testcase_text.add_theme_font_size_override("bold_italics_font_size", Settings.codefont_size + 8.0)

# ? A method used to set the instructions and test case variables for this class.
# ? Accessed by other classes freely, since this class and the node its attached to is under a Global group
func set_instruct_case(instructions: String, cases: String, has_input: bool) -> void:
	instructions_text.bbcode_text = instructions
	has_stdin = has_input
	testcase_text.bbcode_text = cases

func set_points(points_from_question) -> void:
	points_to_give = points_from_question

func set_code(preset_code: String) -> void:
	code.text = preset_code

func set_output_text(output_text: String) -> void:
	console.bbcode_text = "Output:\n" + output_text.strip_edges()

func set_stdin(stdin_from_case: Variant) -> void:
	stdin = stdin_from_case

func set_expected_output(case_output: Array, case_count: int) -> void:
	expected_output = case_output
	expected_output_count = case_count

func set_progress_var(npc_name_var: String, mission_name_var: , mission_done_var: String) -> void:
	npc_name = npc_name_var
	mission_name = mission_name_var
	mission_done = mission_done_var

func set_dialogue(bool_set: bool, dialogue: String) -> void:
	has_dialogue_after = bool_set
	dialogue_to_play = dialogue

func set_replay_lesson(dialogue: String) -> void:
	replay_lesson = dialogue

var vars_to_check = ""
var number_of_vars = 0

func set_vars_to_check(set_vars: String) -> void:
	var varray: Array = []
	vars_to_check = set_vars
	varray.assign((vars_to_check).split("\n"))
	number_of_vars = varray.size()


func get_vars_to_check() -> String:
	return vars_to_check

func _on_run_btn_pressed() -> void:
	var code_to_pass = code.text + "\n\n# Anything under this comment is for running test cases\n"

	if has_stdin:
		for case in range(0, expected_output_count):
			code_to_pass += vars_to_check + "main()\n"
	else:
		code_to_pass += vars_to_check + "main()"
	print(code_to_pass)
	execute_code(code_to_pass)

func check_credits() -> void:
	var check_http = HTTPRequest.new()
	add_child(check_http)

	JDoodle.get_spent_credits(check_http)
	
	await check_http.request_completed

	check_http.queue_free()

func execute_code(script: String) -> void:
	var regex = RegEx.new()

	check_credits()
	SceneManager.show_loading()
	if !has_stdin:
		# CodeX.execute_code(script, "", http)
		JDoodle.execute_code(script, "", http) # ? Un-comment this line if CodeX API goes offline again
	else:
		regex.compile("input\\('.*'\\)|input\\(\".*\"\\)")
		var result = regex.search(script)

		print(result)
		if result == null:
			await get_tree().create_timer(1.5).timeout
			set_output_text("[color=red]ERROR: Executed code does not contain any input() functions.[/color]")
			return
		SceneManager.reset_animplayer()

		script = regex.sub(script, "input('')", true)
		print(script)
		# CodeX.execute_code(script, stdin, http)
		JDoodle.execute_code(script, stdin, http) # ? Un-comment this line if CodeX API goes offline again

func verify_user_output(unverified_output: String) -> String:
	var split_output: Array[String] = []

	unverified_output = unverified_output.strip_edges()

	split_output.assign((unverified_output).split("\n"))
	
	var verified_output = ""

	if number_of_vars != 0:
		pass
	
	if split_output.size() < expected_output_count:
		output_is_correct = false
		return "\n[color=red]ERROR: Executed code only has " + str(split_output.size()) + " output lines, expected " + str(expected_output_count) + " lines.[/color]"

	if split_output.size() > expected_output_count:
		output_is_correct = false
		return "\n[color=red]ERROR: Executed code has " + str(split_output.size()) + " output lines, only expected " + str(expected_output_count) + " lines.[/color]"

	var passed_cases: int = 0

	for i in range(0, expected_output_count):
		if str(split_output[i]) == str(expected_output[i]):
			passed_cases += 1
			verified_output += "\nTest Case " + str(i+1) + ": [color=green]Passed.[/color]"
		else:
			verified_output += "\nTest Case " + str(i+1) + ": [color=red]Failed.[/color]"

	if passed_cases == expected_output_count:
		output_is_correct = true
		SaveGameManager.set_points(points_to_give)
		SaveGameManager.set_progress(npc_name, mission_name, mission_done, true)

	return verified_output


func _on_exec_script_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		print(json.output)

		set_output_text(json.output + verify_user_output(json.output))
		SceneManager.reset_animplayer()

		if output_is_correct:
			await get_tree().create_timer(1.0).timeout
			Dialogic.start(dialogue_to_play)
			await Dialogic.timeline_ended
			await get_tree().create_timer(0.5).timeout
			get_tree().call_group("ui", "close_code_ui")
			vars_to_check = ""
			PlayerGlobalVars.set_player_movement(true)
			set_code("")			
			set_output_text("")
					
	else:
		set_output_text("[color=red]ERROR" + str(response_code) + ": " + json.error.message.capitalize() + "[/color]")
		print(json)
		SceneManager.reset_animplayer()


func _on_view_instructions_pressed() -> void:
	if !anim.is_playing():
		if !is_showing_instructions:
			show_instructions_panel()
		else:
			hide_instructions_panel()


func show_instructions_panel() -> void:
	if !anim.is_playing():
		anim.play("show_instruction")
		is_showing_instructions = true
		view_instruction_btn.text = "Hide Instructions & Test Cases"

func hide_instructions_panel() -> void:
	anim.play("hide_instruction")
	is_showing_instructions = false
	view_instruction_btn.text = "Show Instructions & Test Cases"

func _on_close_button_pressed() -> void:
	PlayerGlobalVars.set_player_movement(true)
