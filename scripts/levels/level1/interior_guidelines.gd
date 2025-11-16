extends Guidelines

@onready var paths: Dictionary = {
	"mother": $Mom_Guidelines,
	"namdalOne": $Namdal_Guide1,
	"namdalTwo": $Namdal_Guide2,
	"namdalThree": $Namdal_Guide3,
	"seraphius": $Seraphius_Guide,
}


func _ready() -> void:
	super()

func set_path() -> void:
	super()

	if SaveGameManager.get_progress("mother", "intro", "active"):
		paths.mother.show()
		return
	else:
		paths.mother.hide()

	if SaveGameManager.get_progress("namdal", "tutorial", "active"):
		paths.namdalOne.show()
		return
	else:
		paths.namdalOne.hide()
	
	if SaveGameManager.get_progress("namdal", "id_seal", "active"):
		paths.namdalTwo.show()
		return
	else:
		paths.namdalTwo.hide()
	
	if SaveGameManager.get_progress("namdal", "id_seal", "done") && SaveGameManager.get_npc_active("namdal"):
		paths.namdalThree.show()
		return
	else:
		paths.namdalThree.hide()
	
	if SaveGameManager.get_progress("namdal", "id_seal", "done") && SaveGameManager.get_npc_active("seraphius"):
		paths.seraphius.show()
		return
	else:
		paths.seraphius.hide()
