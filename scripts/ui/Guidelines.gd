extends Node2D
class_name Guidelines

func _ready() -> void:
	Settings.SHOW_PATH_UPDATED.connect(set_path)

func set_path() -> void:
	if Settings.show_path:
		self.show()
	else:
		self.hide()