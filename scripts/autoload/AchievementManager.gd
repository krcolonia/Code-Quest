extends CanvasLayer

@onready var achievement_vbox = $MarginContainer/Panel/MarginContainer/VBoxContainer/AchievementScrollContainer/AchievementVBox

var achievement_container = preload("res://scenes/menus/achievement_container/AchievementItemContainer.tscn")

# TODO -> change the retrieved list of achievments from SaveGameManager once it is already stored in DB

func _ready() -> void:
	for item in SaveGameManager.achievements:
		var new_item = achievement_container.instantiate()
		new_item.name_text = SaveGameManager.achievements[item]['name']
		if SaveGameManager.achievements[item]['status'] == false:
			new_item.self_modulate = Color8(116, 116, 116, 255)
		achievement_vbox.add_child(new_item)