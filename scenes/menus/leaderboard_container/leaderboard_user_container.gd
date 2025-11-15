extends Panel

@onready var username_label = $MarginContainer/HBoxContainer/Username
@onready var points_label = $MarginContainer/HBoxContainer/Points

var username_text
var points_text

func _ready() -> void:
	username_label.text = username_text
	points_label.text = points_text
