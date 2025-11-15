extends CanvasLayer
class_name IngameUI

@onready var game_controls: Control = $Controls

@onready var dpad: Control = $Controls/Dpad

#region # ? Individual DPad Buttons
@onready var upBtn: TouchScreenButton = $Controls/Dpad/up/upBtn
@onready var downBtn: TouchScreenButton = $Controls/Dpad/down/downBtn
@onready var leftBtn: TouchScreenButton = $Controls/Dpad/left/leftBtn
@onready var rightBtn: TouchScreenButton = $Controls/Dpad/right/rightBtn
#endregion

@onready var interactBtn: Button = $Controls/InteractButton
@onready var runBtn: TouchScreenButton = $Controls/runButton/TouchScreenButton

#region # ? Coding UI Elements
@onready var code_ui: CanvasLayer = $CodingUI
@onready var code_input: CodeEdit = $CodingUI/CodingPanel/MarginContainer/VBoxContainer/CodeEdit
@onready var code_output: RichTextLabel = $CodingUI/CodingPanel/MarginContainer/VBoxContainer/OutputPanel/MarginContainer/Output
#endregion

#region # ? Pause Menu Elements
@onready var pauseBtn: Button = $Controls/pauseBtn
@onready var pause_ui: CanvasLayer = $PauseUI
#endregion

@onready var debug_monitor := $Controls/MonitorOverlay

#region # ? Journal Menu UI Elements
@onready var journal_ui := $JournalUI
@onready var journalMenuBtn := $Controls/journalBtn
@onready var close_journal := $JournalUI/BackgroundPanel/CloseButton
@onready var points_display := $JournalUI/BackgroundPanel/MarginContainer/JournalMenu/MarginContainer/scorePanel/MarginContainer/HBoxContainer/Points
#endregion

func _ready() -> void:
	self.show()

	#region # ? DPad Buttons signal connection
	upBtn.pressed.connect(_on_up_btn_pressed)
	downBtn.pressed.connect(_on_down_btn_pressed)
	leftBtn.pressed.connect(_on_left_btn_pressed)
	rightBtn.pressed.connect(_on_right_btn_pressed)
	runBtn.pressed.connect(_on_run_btn_pressed)
	
	upBtn.released.connect(_on_up_btn_released)
	downBtn.released.connect(_on_down_btn_released)
	leftBtn.released.connect(_on_left_btn_released)
	rightBtn.released.connect(_on_right_btn_released)
	runBtn.released.connect(_on_run_btn_released)
	#endregion

	pauseBtn.button_down.connect(_on_pause_btn_down)
	pauseBtn.button_up.connect(_on_pause_btn_up)

	journalMenuBtn.button_down.connect(_on_journal_btn_down)
	journalMenuBtn.button_up.connect(_on_journal_btn_up)

	close_journal.pressed.connect(_on_journal_close_btn_pressed)

	interactBtn.button_down.connect(_on_interact_btn_down)
	interactBtn.button_up.connect(_on_interact_btn_up)

	interactBtn.hide()

	if SaveGameManager.get_progress("mother", "intro", "done"):
		journalMenuBtn.show()
	else:
		journalMenuBtn.hide()

	PlayerGlobalVars.movement_updated.connect(_update_control_visibility)
	SaveGameManager.progress_updated.connect(_update_journal_visibility)

	points_display.text = str(SaveGameManager.get_points())
	print(points_display.text)
	SaveGameManager.add_points.connect(_update_points_ui)

func _update_journal_visibility() -> void:
	if SaveGameManager.get_progress("mother", "intro", "done"):
		journalMenuBtn.show()
	else:
		journalMenuBtn.hide()

func _update_control_visibility() -> void:
	if PlayerGlobalVars.can_move:
		game_controls.show()
	else:
		game_controls.hide()

func _update_points_ui() -> void:
	print('points added')
	points_display.text = str(SaveGameManager.get_points())

# ? Hide/Show Dpad Function
func hide_dpad() -> void:
	dpad.hide()
	runBtn.hide()

func show_dpad() -> void:
	dpad.show()
	runBtn.show()

# ? Action Pressed
func _on_up_btn_pressed() -> void:
	Input.action_press("ui_up")
	upBtn.global_position.y += 4
	upBtn.modulate = Color(0.7, 0.7, 0.7)

func _on_down_btn_pressed() -> void:
	Input.action_press("ui_down")
	downBtn.global_position.y += 4
	downBtn.modulate = Color(0.7, 0.7, 0.7)

func _on_left_btn_pressed() -> void:
	Input.action_press("ui_left")
	leftBtn.global_position.y += 4
	leftBtn.modulate = Color(0.7, 0.7, 0.7)

func _on_right_btn_pressed() -> void:
	Input.action_press("ui_right")
	rightBtn.global_position.y += 4
	rightBtn.modulate = Color(0.7, 0.7, 0.7)

func _on_run_btn_pressed() -> void:
	Input.action_press("ui_sprint")
	runBtn.global_position.y += 4
	runBtn.modulate = Color(0.7, 0.7, 0.7)

# ? Action Released
func _on_up_btn_released() -> void:
	Input.action_release("ui_up")
	upBtn.global_position.y -= 4
	upBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_down_btn_released() -> void:
	Input.action_release("ui_down")
	downBtn.global_position.y -= 4
	downBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_left_btn_released() -> void:
	Input.action_release("ui_left")
	leftBtn.global_position.y -= 4
	leftBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_right_btn_released() -> void:
	Input.action_release("ui_right")
	rightBtn.global_position.y -= 4
	rightBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_run_btn_released() -> void:
	Input.action_release("ui_sprint")
	runBtn.global_position.y -= 4
	runBtn.modulate = Color(1.0, 1.0, 1.0)

# ? Interaction Button Functions
func enable_interact_button() -> void:
	interactBtn.show()

func disable_interact_button() -> void:
	interactBtn.hide()

func _on_interact_button_pressed() -> void:
	var interact_event = InputEventAction.new()
	interact_event.action = "ui_interact"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)

func _on_interact_btn_down() -> void:
	interactBtn.global_position.y += 4
	interactBtn.modulate = Color(0.7, 0.7, 0.7)

func _on_interact_btn_up() -> void:
	interactBtn.global_position.y -= 4
	interactBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_sprint_button_pressed() -> void:
	var interact_event = InputEventAction.new()
	interact_event.action = "ui_sprint"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)


# ? Coding UI Functions
func show_code_ui():
	get_tree().call_group("player", "stop_movement")
	game_controls.hide()
	code_ui.set_font()
	code_ui.show()

func close_code_ui():
	game_controls.show()
	code_ui.hide()

func _on_close_coding_button_pressed() -> void:
	get_tree().call_group("player", "continue_movement")
	game_controls.show()
	code_ui.hide()

# ? Pause Menu Functions
func _on_pause_btn_pressed() -> void:
	game_controls.hide()
	pause_ui.show()

func _on_pause_btn_down() -> void:
	pauseBtn.global_position.y += 4
	pauseBtn.modulate = Color(0.7, 0.7, 0.7)


func _on_pause_btn_up() -> void:
	pauseBtn.global_position.y -= 4
	pauseBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_journal_btn_down() -> void:
	journalMenuBtn.global_position.y += 4
	journalMenuBtn.modulate = Color(0.7, 0.7, 0.7)


func _on_journal_btn_up() -> void:
	journalMenuBtn.global_position.y -= 4
	journalMenuBtn.modulate = Color(1.0, 1.0, 1.0)

func _on_resume_btn_pressed() -> void:
	Settings.loadData()
	game_controls.show()
	pause_ui.hide()

func _on_journal_btn_pressed() -> void:
	game_controls.hide()
	journal_ui._set_current_npc()
	journal_ui._set_lessons()
	journal_ui.show()

func _on_journal_close_btn_pressed() -> void:
	game_controls.show()
	journal_ui.hide()
	journal_ui._set_current_npc()
	journal_ui._set_lessons()
