extends Node

@onready var studyhall_region = $StudyHall
@onready var forge_region = $BlacksmithForge
@onready var library_region = $Library

func _ready() -> void:
	studyhall_region.body_entered.connect(_on_study_area)
	forge_region.body_entered.connect(_on_forge_area)
	library_region.body_entered.connect(_on_library_area)

func _on_study_area(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("academe")
		await Music.tween.finished
		Music.set_stream(Music.tracks.STUDY)
		Music.fade_in()
		print('in study hall')
		
func _on_forge_area(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("forge")
		await Music.tween.finished
		Music.set_stream(Music.tracks.FORGE)
		Music.fade_in()
		print('in forge')

func _on_library_area(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("library")
		await Music.tween.finished
		Music.set_stream(Music.tracks.LIBRARY)
		Music.fade_in()
		print('in_library')
