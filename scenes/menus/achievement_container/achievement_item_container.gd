extends Panel

@onready var achievement_name = $MarginContainer/name

var name_text

func _ready() -> void:
	achievement_name.text = name_text