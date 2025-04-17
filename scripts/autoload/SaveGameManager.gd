extends Node

const SAVE_GAME_PATH: String = "user://save_data.save"

var global_position: Vector2 = Vector2.ZERO

var points: int = 0
var loaded_data = null
var data: Dictionary
var progress: Dictionary = {
	"prologue": {
		"active": true,
	},
	"mother": {
		"active": false,
		"tasks": {
			"intro": {
				"active": false,
				"done": false,
			},
		},
	},
	"namdal": {
		"active": false,
		"tasks": {
			"tutorial": {
				"active": false,
				"intro": false,
				"code_ui": false,
				"case_ui": false,
				"done": false,
			},
			"id_seal": {
				"active": false,				
				"intro": false,
				"done": false,
			},
		},
	},
	"guards": {

		"active": false,
		"tasks": {
			"unblock_way": {
				"active": false,
				"done": false,
			},
			"lead_user_academe": {
				"active": false,
				"done": false,
			},
		},
	},
	"seraphius": {
		"active": false,
		"tasks": {
			"intro": {
				"active": false,
				"done": false,
			},
			"lesson_printing": {
				"active": false,
				"dialogue": false,				
				"item1": false,
				"done": false,
			},
		},
	},
	"lorem": {
		"active": false,
		"tasks": {
			"intro": {
				"active": false,
				"done": false,
			},
			"lesson_comment": {
				"active": false,
				"dialogue": false,				
				"done": false,
			},
		},
	},
	"thalvin": {
		"active": false,
		"tasks": {
			"lesson_datatypes": {
				"active": false,
				"dialogue": false,				
				"done": false,
			},
			"lesson_variables": {
				"active": false,
				"dialogue": false,				
				"done": false,
			},
		},
	},
	"tiber": {
		"active": false,
		"tasks": {
			"lesson_input": {
				"active": false,				
				"done": false
			},
		},
	},
	"amara": {
		"active": false,
		"tasks": {
			"lesson_varnaming": {
				"active": false,				
				"done": false,
			},
		},
	},
	"garrick": {
		"active": false,
		"tasks": {
			"lesson_arithmeticop": {
				"active": false,				
				"done": false,
			},
			"lesson_assignmentop": {
				"active": false,				
				"done": false,
			},
		},
	},
	"matheus": {
		"active": false,
		"tasks": {
			"lesson_comparisonop": {
				"active": false,				
				"done": false,
			},
			"lesson_logicalop": {
				"active": false,				
				"done": false,
			},
		},
	},
	"indenta": {
		"active": false,
		"tasks": {
			"lesson_indentation": {
				"active": false,				
				"done": false,
			},
			"lesson_ifelse": {
				"active": false,				
				"done": false,
			},
		},
	},
	"yara": {
		"active": false,
		"tasks": {
			"lesson_matchcase": {
				"active": false,				
				"done": false,
			},
		},
	},
	"circe": {
		"active": false,
		"tasks": {
			"lesson_forloop": {
				"active": false,				
				"done": false,
			},
			"lesson_whileloop": {
				"active": false,				
				"done": false,
			},
			"lesson_combineloopsfuncs": {
				"active": false,				
				"done": false,
			},
		},
	},
	"sage": {
		"active": false,
		"tasks": {
			"lesson_func": {
				"active": false,
				"done": false,
			},
			"lesson_funcparams": {
				"active": false,				
				"done": false,
			},
			"lesson_funcreturn": {
				"active": false,				
				"done": false,
			},
		},
	},
	"arno": {
		"active": false,
		"tasks": {
			"lesson_list": {
				"active": false,				
				"done": false,
			},
			"lesson_passlisttofunc": {
				"active": false,				
				"done": false,
			},
		},
	},
	"theraf": {
		"active": false,
		"tasks": {
			"chapter1_exam": {
				"active": false,				
				"done": false
			},
			"chapter2_exam": {
				"active": false,				
				"done": false
			}
		}
	}
}

var achievements: Dictionary = {
	"achieve1" : {
		"name": "Baby  Steps",
		"descriotion": "",
		"points": 25,
		"status": false
	},
	"achieve2" : {
		"name": "Certified  Scholar  I",
		"descriotion": "",
		"points": 25,
		"status": false
	},
	"achieve3" : {
		"name": "Paths  Forged  Anew",
		"descriotion": "",
		"points": 25,
		"status": false
	},
	"achieve4" : {
		"name": "Certified  Scholar  II",
		"descriotion": "",
		"points": 25,
		"status": false
	},
}

var has_save: bool = false

#region # ? Getter and Setter for Active NPCs
func get_npc_active(npc_name: String) -> bool:
	return progress[npc_name]["active"]

signal npc_activity

func set_npc_active(npc_name, bool_set) -> void:
	progress[npc_name]["active"] = bool_set
	npc_activity.emit()
#endregion

#region # ? Getter and Setter for User NPC Progress
func get_progress(npc_name: String, mission_name: , mission_done: String) -> bool:
	return progress[npc_name]["tasks"][mission_name][mission_done]

signal progress_updated

func set_progress(npc_name: String, mission_name: , mission_done: String, bool_set: bool) -> void:
	progress[npc_name]["tasks"][mission_name][mission_done] = bool_set
	progress_updated.emit()
#endregion

#region # ? Getter and Setter for User Points
func get_points() -> int:
	return points

signal add_points

func set_points(point_to_set: int) -> void:
	points += point_to_set
	add_points.emit()
#endregion

#region # ? Getter and Setter for Achievements
func get_achievement(achieveNum: String) -> bool:
	return achievements[achieveNum]["status"]

func set_achievement(achieveNum: String, status: bool) -> void:
	achievements[achieveNum]["status"] = status
	points += achievements[achieveNum]["points"]

#endregion

func get_prologue_done() -> bool:
	return progress["prologue"]["active"]

func set_prologue_done() -> void:
	progress["prologue"]["active"] = false

func save_script_output(npc_name: String, lesson: String,script: String, output: String) -> void:
	progress[npc_name]["tasks"][lesson]["script"] = script
	progress[npc_name]["tasks"][lesson]["output"] = output

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_GAME_PATH)


func write_save_details() -> void:
	var file: FileAccess

	var save_http = HTTPRequest.new()
	add_child(save_http)
	save_http.request_completed.connect(self._save_game_http_request_completed)

	var pts_http = HTTPRequest.new()
	add_child(pts_http)
	pts_http.request_completed.connect(self._user_points_http_request_completed)

	var achieve_http = HTTPRequest.new()
	add_child(achieve_http)
	achieve_http.request_completed.connect(self._achievement_http_request_completed)

	file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)

	var player = SceneManager.player
	var map_name = SceneManager.loaded_stage

	data = {
		"global_position": { # ? Player's global position in current map
			"x": player.position.x,
			"y": player.position.y,
			"dir": PlayerGlobalVars.get_dir(),
			"loc": PlayerGlobalVars.current_location
		},
		"map_name": map_name.map_name, # ? Map that player is currently in
		"progress_data": progress,
		"achievements": achievements,
		"points": points,
	}

	file.store_var(data)
	file.close()

	Firebase.update_document("leaderboards/%s" % Firebase.user_info.id, { "points": points, "username": Firebase.user_info.username }, pts_http)
	await pts_http.request_completed
	Firebase.update_document("progress/%s" % Firebase.user_info.id, data, save_http)
	await save_http.request_completed
	Firebase.update_document("achievements/%s" % Firebase.user_info.id, data["achievements"], achieve_http)
	await finished_saving

	save_http.request_completed.disconnect(self._save_game_http_request_completed)
	save_http.queue_free()

	pts_http.request_completed.disconnect(self._user_points_http_request_completed)
	pts_http.queue_free()

	has_save = true

func load_save_details() -> void:
	var file: FileAccess
	var http: HTTPRequest

	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_load_save_http_request)

	Firebase.get_document("progress/%s" % Firebase.user_info.id, http)

	await finished_loading
	http.queue_free()

	if loaded_data == null:
		http = HTTPRequest.new()
		add_child(http)
		http.request_completed.connect(_save_game_http_request_completed)

		# ? This makes the save data start at the very beginning of the game.
		# ! This only executes if BOTH local and cloud saves are nowhere to be seen!
		loaded_data = {
			"global_position": {
				"x": -440.0,
				"y": -88.0,
				"dir": "RIGHT",
			},
			"map_name": "LEVEL1_INTERIOR",
			"progress_data": progress,
			"achievements": achievements,
			"points": points,
		}

		http.request_completed.disconnect(self._save_game_http_request_completed)
		http.queue_free()

	if !save_exists():
		file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
		file.store_var(loaded_data)
		file.close()
	
	file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	var local_data: Dictionary = file.get_var()

	if local_data == loaded_data:
		data.merge(local_data, true)
	else: 
		file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
		file.store_var(loaded_data)
		file.close()
		data.merge(loaded_data, true)
	progress.merge(data.progress_data, true)
	achievements.merge(data.achievements, true)
	points = loaded_data.points

	# print(data)

func get_loaded_save(body: PackedByteArray) -> void:
	loaded_data = JSON.parse_string(body.get_string_from_utf8())


signal finished_saving

func _save_game_http_request_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if response_code == 200:
		print('Save Game Data to DB Successful')
	else:
		print('Save Game Data to DB Unsuccessful')
	finished_saving.emit()

signal finished_loading

func _load_save_http_request(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200 && json != null:
		get_loaded_save(body)
		print('Load Save Game Data from DB Successful')
	else:
		print('Load Save Game Data from DB Unsuccessful')
	finished_loading.emit()

signal updated_db_points

func _user_points_http_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200 && json != null:
		print('Player Points Saved to DB Successful')
	else:
		print('Player Points Saved to DB Unsuccessful')
	updated_db_points.emit()

signal updated_db_achievements

func _achievement_http_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200 && json != null:
		print('Player Points Saved to DB Successful')
	else:
		print('Player Points Saved to DB Unsuccessful')
	updated_db_achievements.emit()
