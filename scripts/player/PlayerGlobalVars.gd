extends Node2D

var gender: String

enum FacingDirection {UP, DOWN, LEFT, RIGHT}

var current_direction: FacingDirection
var current_location: String
var can_move: bool = true

var show_debug = false

const USER_INFO_PATH = "user://user_info.save"

signal movement_updated
signal location_updated

func _ready() -> void:
	if show_debug:
		DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED

func set_player_location(loc: String) -> void:
	current_location = loc
	location_updated.emit()


func set_player_movement(bool_set: bool) -> void:
	can_move = bool_set
	movement_updated.emit()

func get_gender() -> void:
	var file
	if(FileAccess.file_exists(USER_INFO_PATH)):
		file = FileAccess.open(USER_INFO_PATH, FileAccess.READ).get_var()
	gender = file.gender

func get_dir() -> String:
	match current_direction:
		FacingDirection.UP:
			return 'UP'
		FacingDirection.DOWN:
			return 'DOWN'
		FacingDirection.LEFT:
			return 'LEFT'
		FacingDirection.RIGHT:
			return 'RIGHT'
		_:
			return 'UNDEFINED'
