extends Guidelines

#region # ? Guidelines
	#region # ? Guidelines from House
@onready var haus2tav = $HouseGuidelines/Tavern
@onready var haus2acad = $HouseGuidelines/Academe
@onready var haus2forg1 = $HouseGuidelines/Forge1
@onready var haus2forg2 = $HouseGuidelines/Forge2
@onready var haus2lib = $HouseGuidelines/Library
	#endregion

	#region # ? Guidelines from Tavern
@onready var tav2haus = $TavernGuidelines/House
@onready var tav2acad = $TavernGuidelines/Academe
@onready var tav2forg1 = $TavernGuidelines/Forge1
@onready var tav2forg2 = $TavernGuidelines/Forge2
@onready var tav2lib = $TavernGuidelines/Library
	#endregion

	#region # ? Guidelines from Academe
@onready var acad2haus = $AcademeGuidelines/House
@onready var acad2tav = $AcademeGuidelines/Tavern
@onready var acad2forg1 = $AcademeGuidelines/Forge1
@onready var acad2forg2 = $AcademeGuidelines/Forge2
@onready var acad2lib = $AcademeGuidelines/Library
	#endregion

	#region # ? Guidelines from Forge
@onready var forg1tohaus = $Forge1Guidelines/House
@onready var forg1totav = $Forge1Guidelines/Tavern
@onready var forg1toacad = $Forge1Guidelines/Academe
@onready var forg1toforg2 = $Forge1Guidelines/Forge2
@onready var forg1tolib = $Forge1Guidelines/Library

@onready var forg2tohaus = $Forge2Guidelines/House
@onready var forg2totav = $Forge2Guidelines/Tavern
@onready var forg2toacad = $Forge2Guidelines/Academe
@onready var forg2toforg1 = $Forge2Guidelines/Forge1
@onready var forg2tolib = $Forge2Guidelines/Library
	#endregion

	#region # ? Guidelines from Library
@onready var lib2haus = $LibraryGuidelines/House
@onready var lib2tav = $LibraryGuidelines/Tavern
@onready var lib2acad = $LibraryGuidelines/Academe
@onready var lib2forg1 = $LibraryGuidelines/Forge1
@onready var lib2forg2 = $LibraryGuidelines/Forge2
	#endregion

	#region # ? Area2D Nodes for level regions
@onready var town_region = $Town
@onready var house_region = $House
@onready var tavern_region = $Tavern
@onready var academe_region = $Academe
@onready var forge_region = $Forge
@onready var library_region = $Library

@onready var north_region = $North
@onready var center_region = $Center
@onready var south_region = $South
	#endregion
#endregion

func _ready () -> void:
	super()
	town_region.body_entered.connect(_on_town_region)
	house_region.body_entered.connect(_on_house_region)
	tavern_region.body_entered.connect(_on_tavern_region)
	academe_region.body_entered.connect(_on_academe_region)
	forge_region.body_entered.connect(_on_forge_region)
	library_region.body_entered.connect(_on_library_region)

	north_region.body_entered.connect(_on_north_region)
	center_region.body_entered.connect(_on_center_region)
	south_region.body_entered.connect(_on_south_region)

func set_path() -> void:
	super()

#region # ? Area2D Functions
	#region # ? Level Regions with connected NPCs and Maps
func _on_town_region(body: Node2D) -> void:
	if body.name == "Player":
		await Music.tween.finished
		Music.set_stream(Music.tracks.TOWN)
		Music.fade_in()


func _on_house_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("house")
		hide_all_guides()
		if has_tavern():
			hide_all_guides()
			haus2tav.show()
			return
		if has_academe():
			hide_all_guides()
			haus2acad.show()
			return
		if has_forge1():
			hide_all_guides()
			haus2forg1.show()
			return
		if has_forge2():
			hide_all_guides()
			haus2forg2.show()
			return
		if has_library():
			hide_all_guides()
			haus2lib.show()
			return

func _on_tavern_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("tavern")
		if has_tavern():
			haus2tav.show()
			return
		hide_all_guides()
		if has_house():
			tav2haus.show()
			return
		if has_academe():
			tav2acad.show()
			return
		if has_forge1():
			tav2forg1.show()
			return
		if has_forge2():
			tav2forg2.show()
			return
		if has_library():
			tav2lib.show()
			return

func _on_academe_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("academe")
		if has_academe():
			haus2acad.show()
			return
		hide_all_guides()
		if has_house():
			acad2haus.show()
			return
		if has_tavern():
			acad2tav.show()
			return
		if has_forge1():
			acad2forg1.show()
			return
		if has_forge2():
			acad2forg2.show()
			return
		if has_library():
			acad2lib.show()
			return

func _on_forge_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("forge")
		if has_forge1():
			haus2forg1.show()
			return
		if has_forge2():
			haus2forg2.show()
			return
		hide_all_guides()
		if has_forge1():
			if has_house():
				forg1tohaus.show()
				return
			if has_tavern():
				forg1totav.show()
				return
			if has_academe():
				forg1toacad.show()
				return
			if has_forge2():
				forg1toforg2.show()
				return
			if has_library():
				forg1tolib.show()
				return
			return
		if has_forge2():
			if has_house():
				forg2tohaus.show()
				return
			if has_tavern():
				forg2totav.show()
				return
			if has_academe():
				forg2toacad.show()
				return
			if has_forge1():
				forg2toforg1.show()
				return
			if has_library():
				forg2tolib.show()
				return
			return

func _on_library_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("library")
		if has_library():
			haus2lib.show()
			return
		hide_all_guides()
		if has_house():
			lib2haus.show()
			return
		if has_academe():
			lib2acad.show()
			return
		if has_tavern():
			lib2tav.show()
			return
		if has_forge1():
			lib2forg1.show()
			return
		if has_forge2():
			lib2forg2.show()
			return
	#endregion

	#region # ? Map Regions with no connected NPCs and Maps
func _on_north_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("north")
		pass

func _on_center_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("center")
		pass
	
func _on_south_region(body: Node2D) -> void:
	if body.name == "Player":
		PlayerGlobalVars.set_player_location("south")
		pass
	#endregion
#endregion

#region # ? Methods for checking location with active NPCs
func has_house() -> bool:
	if SaveGameManager.get_npc_active("mother"):
		return true
	print('has no house')
	return false

func has_tavern() -> bool:
	if SaveGameManager.get_npc_active("namdal"):
		return true
	print('has no tavern')
	return false

func has_academe() -> bool:
	if SaveGameManager.get_npc_active("seraphius"):
		return true
	if SaveGameManager.get_npc_active("thalvin"):
		return true
	if SaveGameManager.get_npc_active("lorem"):
		return true
	if SaveGameManager.get_npc_active("tiber"):
		return true
	print('has no acad')
	return false

func has_forge1() -> bool:
	if SaveGameManager.get_npc_active("amara"):
		return true
	print('has no forge1')
	return false

func has_forge2() -> bool:
	if SaveGameManager.get_npc_active("garrick"):
		return true
	print('has no forge2')
	return false

func has_library() -> bool:
	if SaveGameManager.get_npc_active("matheus"):
		return true
	if SaveGameManager.get_npc_active("yara"):
		return true
	if SaveGameManager.get_npc_active("indenta"):
		return true
	print('has no library')
	return false
#endregion

func hide_all_guides() -> void:
	haus2tav.hide()
	haus2acad.hide()
	haus2forg1.hide()
	haus2forg2.hide()
	haus2lib.hide()

	tav2haus.hide()
	tav2acad.hide()
	tav2forg1.hide()
	tav2forg2.hide()
	tav2lib.hide()

	acad2haus.hide()
	acad2tav.hide()
	acad2forg2.hide()
	acad2lib.hide()

	forg1tohaus.hide()
	forg1totav.hide()
	forg1toacad.hide()
	forg1toforg2.hide()
	forg1tolib.hide()

	forg2tohaus.hide()
	forg2totav.hide()
	forg2toforg1.hide()
	forg2tolib.hide()

	lib2haus.hide()
	lib2tav.hide()
	lib2acad.hide()
	lib2forg1.hide()
	lib2forg2.hide()