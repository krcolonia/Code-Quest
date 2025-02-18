extends CanvasLayer

@onready var lesson_menu = $BackgroundPanel/MarginContainer/Lessons
@onready var map_menu = $BackgroundPanel/MarginContainer/Map
@onready var journal_menu = $BackgroundPanel/MarginContainer/JournalMenu

@onready var current_npc_portrait = $BackgroundPanel/MarginContainer/JournalMenu/TaskPanel/MarginContainer/VBoxContainer/PortraitMask/NPCPortrait
@onready var current_npc_name = $BackgroundPanel/MarginContainer/JournalMenu/TaskPanel/MarginContainer/VBoxContainer/npcName
@onready var current_npc_loc = $BackgroundPanel/MarginContainer/JournalMenu/TaskPanel/MarginContainer/VBoxContainer/npcLocation
@onready var current_npc_task = $BackgroundPanel/MarginContainer/JournalMenu/TaskPanel/MarginContainer/VBoxContainer/npcTask

@onready var lesson_btn = $BackgroundPanel/MarginContainer/JournalMenu/HBoxContainer/LessonButton
@onready var close_lesson_btn = $BackgroundPanel/MarginContainer/Lessons/CloseLessons

@onready var map_btn = $BackgroundPanel/MarginContainer/JournalMenu/HBoxContainer/MapButton
@onready var close_map_btn = $BackgroundPanel/MarginContainer/Map/CloseMap

@onready var map = $BackgroundPanel/MarginContainer/Map/MapPanel/MarginContainer/MapTexture
@onready var task_in_map = $BackgroundPanel/MarginContainer/Map/MapPanel/MarginContainer/ActiveTexture
@onready var player_in_map = $BackgroundPanel/MarginContainer/Map/MapPanel/MarginContainer/PlayerTexture

func _ready() -> void:
	lesson_btn.pressed.connect(_show_lesson_pressed)
	close_lesson_btn.pressed.connect(_hide_lesson_pressed)
	PlayerGlobalVars.location_updated.connect(_set_player_map)

	map_btn.pressed.connect(_show_map_pressed)
	close_map_btn.pressed.connect(_hide_map_pressed)

func _set_player_map() -> void:
	match PlayerGlobalVars.current_location:
		"house":
			print("house")
			player_in_map.texture = load("res://assets/ui/map/player_house.png")
		"tavern":
			print("tavern")
			player_in_map.texture = load("res://assets/ui/map/player_tavern.png")
		"academe":
			print("academe")
			player_in_map.texture = load("res://assets/ui/map/player_academe.png")
		"forge":
			print("forge")
			player_in_map.texture = load("res://assets/ui/map/player_forge.png")
		"library":
			print("library")
			player_in_map.texture = load("res://assets/ui/map/player_library.png")
		"north":
			print("north")
			player_in_map.texture = load("res://assets/ui/map/player_north.png")
		"center":
			print("center")
			player_in_map.texture = load("res://assets/ui/map/player_center.png")
		"south":
			print("south")
			player_in_map.texture = load("res://assets/ui/map/player_south.png")

func _set_current_npc() -> void:
	if SaveGameManager.get_npc_active("mother"):
		current_npc_portrait.texture = load("res://assets/portraits/Mother.png")
		task_in_map.texture = load("res://assets/ui/map/active_house.png")
		current_npc_name.text = "Mother"
		current_npc_loc.text = "House"
		return
	
	if SaveGameManager.get_npc_active("namdal"):
		current_npc_portrait.texture = load("res://assets/portraits/Namdal.png")
		task_in_map.texture = load("res://assets/ui/map/active_tavern.png")
		current_npc_name.text = "Namdal"
		current_npc_loc.text = "Tavern"
		if !SaveGameManager.get_progress("namdal", "tutorial", "done"):
			current_npc_task.text = "Speak with Namdal before going to the Academe."
			return

		if !SaveGameManager.get_progress("namdal", "id_seal", "done"):
			current_npc_task.text = "Create your Identification Seal for the Academe"
			return
		return
	
	if SaveGameManager.get_npc_active("guards"):
		current_npc_portrait.texture = load("res://assets/portraits/Guard_Skintone1.png")
		current_npc_name.text = "Guards"
		current_npc_loc.text = "Outside Academe"
		return
	
	if SaveGameManager.get_npc_active("seraphius"):
		current_npc_portrait.texture = load("res://assets/portraits/ElderSeraphius.png")
		task_in_map.texture = load("res://assets/ui/map/active_academe.png")
		current_npc_name.text = "Elder Seraphius"
		current_npc_loc.text = "Inside Academe"
		if !SaveGameManager.get_progress("seraphius", "intro", "done"):
			current_npc_task.text = "Enter the Academe for your first day."
			return
		if !SaveGameManager.get_progress("seraphius", "lesson_printing", "done"):
			current_npc_task.text = "Listen to Elder Seraphius' Lesson about using 'print()'"
			return
		return
	
	if SaveGameManager.get_npc_active("thalvin"):
		current_npc_portrait.texture = load("res://assets/portraits/ElderThalvin.png")
		task_in_map.texture = load("res://assets/ui/map/active_academe.png")
		current_npc_name.text = "Elder Thalvin"
		current_npc_loc.text = "Inside Academe"
		return
	
	if SaveGameManager.get_npc_active("lorem"):
		current_npc_portrait.texture = load("res://assets/portraits/ElderLorem.png")
		task_in_map.texture = load("res://assets/ui/map/active_academe.png")
		current_npc_name.text = "Elder Lorem"
		current_npc_loc.text = "Inside Academe"
		return
	
	if SaveGameManager.get_npc_active("tiber"):
		current_npc_portrait.texture = load("res://assets/portraits/ScribeTiber.png")
		task_in_map.texture = load("res://assets/ui/map/active_academe.png")
		current_npc_name.text = "Scribe Tiber"
		current_npc_loc.text = "Academe"
		return
	
	if SaveGameManager.get_npc_active("amara"):
		current_npc_portrait.texture = load("res://assets/portraits/ArtificerAmara.png")
		task_in_map.texture = load("res://assets/ui/map/active_forge.png")
		current_npc_name.text = "Artificer Amara"
		current_npc_loc.text = "Inside Blacksmith's Forge"
		return
	
	if SaveGameManager.get_npc_active("garrick"):
		current_npc_portrait.texture = load("res://assets/portraits/BlacksmithGarrick.png")
		task_in_map.texture = load("res://assets/ui/map/active_forge.png")
		current_npc_name.text = "Blacksmith Garrick"
		current_npc_loc.text = "Outside Blacksmith's Forge"
		return
	
	if SaveGameManager.get_npc_active("matheus"):
		current_npc_portrait.texture = load("res://assets/portraits/SirMatheus.png")
		task_in_map.texture = load("res://assets/ui/map/active_library.png")
		current_npc_name.text = "Sir Matheus"
		current_npc_loc.text = "Outside Village Library"
		return
	
	if SaveGameManager.get_npc_active("indenta"):
		current_npc_portrait.texture = load("res://assets/portraits/LadyIndenta.png")
		task_in_map.texture = load("res://assets/ui/map/active_library.png")
		current_npc_name.text = "Lady Indenta"
		current_npc_loc.text = "Outside Village Library"
		return
	
	if SaveGameManager.get_npc_active("yara"):
		current_npc_portrait.texture = load("res://assets/portraits/ArchivistYara.png")
		task_in_map.texture = load("res://assets/ui/map/active_library.png")
		current_npc_name.text = "Archivist Yara"
		current_npc_loc.text = "Inside Village Library"
		return
	
	if SaveGameManager.get_npc_active("circe"):
		current_npc_portrait.texture = load("res://assets/portraits/LadyCirce.png")
		task_in_map.texture = load("res://assets/ui/map/active_library.png")
		current_npc_name.text = "Lady Circe"
		current_npc_loc.text = "Outside Village Library"
		return
	
	if SaveGameManager.get_npc_active("arno"):
		current_npc_portrait.texture = load("res://assets/portraits/MasterArno.png")
		current_npc_name.text = "Master Arno"
		current_npc_loc.text = "Secluded Order Watchtower"
		return
	
	if SaveGameManager.get_npc_active("sage"):
		current_npc_portrait.texture = load("res://assets/portraits/SageOfReturn.png")
		current_npc_name.text = "Sage of Return"
		current_npc_loc.text = "Secluded Order Watchtower"
		return

var lesson_to_play = ""

func _set_lessons() -> void:	
	if SaveGameManager.get_progress("seraphius", "lesson_printing", "done"):
		$BackgroundPanel/MarginContainer/Lessons/ScrollContainer/MarginContainer/VBoxContainer/printBtn.show()
		lesson_to_play = "Seraphius_LessonRecall"
		if !$BackgroundPanel/MarginContainer/Lessons/ScrollContainer/MarginContainer/VBoxContainer/printBtn.is_connected("pressed", _on_lesson_pressed):
			$BackgroundPanel/MarginContainer/Lessons/ScrollContainer/MarginContainer/VBoxContainer/printBtn.pressed.connect(_on_lesson_pressed)
	
	if SaveGameManager.get_progress("thalvin", "lesson_datatypes", "done"):
		pass

	if SaveGameManager.get_progress("thalvin", "lesson_variables", "done"):
		pass
	
	if SaveGameManager.get_progress("lorem", "lesson_comment", "done"):
		pass
	
	if SaveGameManager.get_progress("tiber", "lesson_input", "done"):
		pass
	
	if SaveGameManager.get_progress("amara", "lesson_varnaming", "done"):
		pass
	
	if SaveGameManager.get_progress("garrick", "lesson_arithmeticop", "done"):
		pass

	if SaveGameManager.get_progress("garrick", "lesson_assignmentop", "done"):
		pass
	
	if SaveGameManager.get_progress("matheus", "lesson_comparisonop", "done"):
		pass
		
	if SaveGameManager.get_progress("matheus", "lesson_comparisonop", "done"):
		pass
	
	if SaveGameManager.get_progress("indenta", "lesson_indentation", "done"):
		pass

	if SaveGameManager.get_progress("indenta", "lesson_ifelse", "done"):
		pass
	
	if SaveGameManager.get_progress("yara", "lesson_matchcase", "done"):
		pass

	if SaveGameManager.get_progress("circe", "lesson_forloop", "done"):
		pass
	if SaveGameManager.get_progress("circe", "lesson_whileloop", "done"):
		pass

	if SaveGameManager.get_progress("circe", "lesson_combineloopsfuncs", "done"):
		pass

	if SaveGameManager.get_progress("arno", "lesson_list", "done"):
		pass

	if SaveGameManager.get_progress("arno", "lesson_passlisttofunc", "done"):
		pass
	
	if SaveGameManager.get_progress("sage", "lesson_func", "done"):
		pass

	if SaveGameManager.get_progress("sage", "lesson_funcparams", "done"):
		pass

	if SaveGameManager.get_progress("sage", "lesson_funcreturn", "done"):
		pass

func _on_lesson_pressed() -> void:
	Dialogic.start(lesson_to_play)

func _show_lesson_pressed() -> void:
	journal_menu.hide()
	lesson_menu.show()

func _hide_lesson_pressed() -> void:
	journal_menu.show()
	lesson_menu.hide()

func _show_map_pressed() -> void:
	journal_menu.hide()
	map_menu.show()

func _hide_map_pressed() -> void:
	journal_menu.show()
	map_menu.hide()