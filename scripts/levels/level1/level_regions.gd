extends Node2D

@onready var house_region = $House
@onready var tavern_region = $Tavern
@onready var academe_tower_region = $AcademeTower

func _ready() -> void:
	house_region.body_entered.connect(_on_house_area)
	tavern_region.body_entered.connect(_on_tavern_area)
	academe_tower_region.body_entered.connect(_on_academe_tower_area)

func _on_house_area(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("house")
		await Music.tween.finished
		Music.set_stream(Music.tracks.HOUSE)
		Music.fade_in()
		print('in house')
	
func _on_tavern_area(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("tavern")
		await Music.tween.finished
		Music.set_stream(Music.tracks.TAVERN)
		Music.fade_in()
		print('in tavern')

func _on_academe_tower_area(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("academe")
		await Music.tween.finished
		Music.set_stream(Music.tracks.ACADEME)
		Music.fade_in()
		print('in academe tower')
