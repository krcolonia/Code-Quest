extends CanvasLayer

# TODO -> rewrite the whole Coding Process

@onready var code: CodeEdit = $CodingPanel/MarginContainer/VBoxContainer/CodeEdit
@onready var console: RichTextLabel = $CodingPanel/MarginContainer/VBoxContainer/OutputPanel/MarginContainer/Output
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var view_instruction_btn: Button = $VBoxContainer/ShowPanel/MarginContainer/ViewInstructions
@onready var instructions_label: RichTextLabel = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/QuestionPanel/MarginContainer/VBoxContainer/Label
@onready var instructions_text: RichTextLabel = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/QuestionPanel/MarginContainer/VBoxContainer/RichTextLabel
@onready var testcase_text: RichTextLabel = $VBoxContainer/InstructionPanel/MarginContainer/VBoxContainer/TestCasePanel/MarginContainer/RichTextLabel

var is_showing_instructions: bool

var has_stdin: bool = false
var expected_output: Array
var expected_output_count: int
var stdin: Variant
var points_to_give: int

var output_is_correct: bool

var has_dialogue_after: bool = false
var dialogue_to_play: String = ""

func _ready() -> void:
	is_showing_instructions = false


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
