extends Node

# ? Game UI and Assets
var normal_dialogue_style: DialogicStyle= load("res://assets/dialogic_styles/CustomDialogueTheme/DialogueTheme.tres")
var tutorial_dialogue_style: DialogicStyle = load("res://assets/dialogic_styles/TutorialDialog/TutorialDialogueStyle.tres")
const DIALOGIC_TIMELINE_PATH := "res://assets/dialogic/timelines/"

func load_all_dialogue_timelines() -> void:
	var timeline_dir: DirAccess = DirAccess.open(DIALOGIC_TIMELINE_PATH)
	var dialogic_timelines: Array = timeline_dir.get_files()

	for timeline in dialogic_timelines:

		Dialogic.preload_timeline(DIALOGIC_TIMELINE_PATH + timeline)

func _ready() -> void:
	normal_dialogue_style.prepare()
	tutorial_dialogue_style.prepare()
	load_all_dialogue_timelines()
