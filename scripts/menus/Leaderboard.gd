extends CanvasLayer

var username_scene = preload("res://scenes/menus/leaderboard_container/LeaderboardUserContainer.tscn")

@onready var usernames_vbox = $MarginContainer/Panel/MarginContainer/VBoxContainer/UserScrollContainer/UsernameVBox
@onready var get_username_req = $GetUsernamesRequest

@export var leaderboard_limit: int = 10
var current_items: int = 0

func _ready() -> void:
	pass

func _reload_leaderboards() -> void:
	current_items = 0
	SceneManager.show_loading()
	Firebase.get_leaderboards(get_username_req)

func _on_get_usernames_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	var result_body = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		var leaderboard = sort_leaderboard(result_body)
		var old_leaderboard = usernames_vbox.get_children()
		
		for child in old_leaderboard:
			child.free()

		for user in leaderboard:
			if current_items < leaderboard_limit:
				var new_user = username_scene.instantiate() # ? Creates a new instance of the preloaded username container scene
				new_user.username_text = user["username"] # ? Sets the text of instanced scene to username from retrieved JSON
				new_user.points_text = str(user["points"]) # ? Sets the text of instanced scene to username from retrieved JSON
				usernames_vbox.add_child(new_user) # ? Adds the instanced scene to current scene
				current_items += 1 # ? increments this var, to keep count of how many users are already in the leaderboard
			else:
				break
		
		add_remaining_empty_users()
	SceneManager.reset_animplayer()

func add_remaining_empty_users() -> void:
	if current_items < leaderboard_limit:
		var remaining = leaderboard_limit - current_items
		for item in range(remaining):
			var empty_user = username_scene.instantiate()
			empty_user.username_text = ""
			empty_user.points_text = ""
			usernames_vbox.add_child(empty_user)
	else:
		return

func sort_leaderboard(response_body):
	var entries = []
	for uid in response_body.keys():
		var entry = response_body[uid]
		entries.append(entry)

	entries.sort_custom(self._compare_points_desc)
	print(entries)
	return entries

func _compare_points_desc(a, b):
	if a["points"] < b["points"]:
		return false
	return true
