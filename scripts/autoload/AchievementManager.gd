extends CanvasLayer

const achievements: Dictionary = {
	"achieve1" : {
		"name": "Baby Steps",
		"descriotion": "",
		"points": 50,
		"status": false
	},
	"achieve2" : {
		"name": "Certified Scholar I",
		"descriotion": "",
		"points": 50,
		"status": false
	},
	"achieve3" : {
		"name": "Paths Forged Anew",
		"descriotion": "",
		"points": 50,
		"status": false
	},
	"achieve4" : {
		"name": "Certified Scholar II",
		"descriotion": "",
		"points": 50,
		"status": false
	},
}

@onready var achievement_vbox = $MarginContainer/Panel/MarginContainer/VBoxContainer/AchievementScrollContainer/AchievementVBox

var achievement_container = preload("res://scenes/menus/achievement_container/AchievementItemContainer.tscn")

func _ready() -> void:
	for item in achievements:
		var new_item = achievement_container.instantiate()
		new_item.name_text = achievements[item]['name']
		if achievements[item]['status'] == false:
			new_item.self_modulate = Color8(116, 116, 116, 255)
		achievement_vbox.add_child(new_item)