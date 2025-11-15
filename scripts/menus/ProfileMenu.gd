extends CanvasLayer

@onready var user_pfp = $MarginContainer/Panel/MarginContainer/VBoxContainer/ProfileContainer/PfpMask/ProfilePhoto
@onready var username_label = $MarginContainer/Panel/MarginContainer/VBoxContainer/ProfileContainer/UsernameLabel

@onready var image_request: HTTPRequest = $PfpImageRequest
signal retrieve_pfp_signal

@onready var username_request: HTTPRequest = $UsernameRequest
signal retrieve_username_signal

var save_path: String = "user://user_info.save"
var user_info: Dictionary

func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			pass
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			if self.visible:
				_reload_profile()

func _ready() -> void:
	image_request.request_completed.connect(_on_pfp_image_request_completed)
	username_request.request_completed.connect(_on_retrieve_username_completed)

func _reload_profile() -> void:
	SceneManager.show_loading()
	Firebase.get_profile_pic(image_request)
	await retrieve_pfp_signal
	Firebase.get_document("users/%s" % Firebase.user_info.id, username_request)
	await retrieve_username_signal
	SceneManager.reset_animplayer()

	var file: FileAccess
	if !FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.WRITE)
	else:
		file = FileAccess.open(save_path, FileAccess.READ_WRITE)

	file.store_var(user_info)

	print(user_info)
	
	file.close()

	username_label.text = str(user_info.username)

	if FileAccess.file_exists(save_path):
		var profile_save = FileAccess.open(save_path, FileAccess.READ).get_var()
		print(str(profile_save.username))

func _on_visit_site_button_pressed() -> void:
	OS.shell_open("https://code-quest-pytome.web.app/") # ? Launches account management website in mobile device's default browser
	# TODO -> replace the OS.shell_open function with an android AAR plugin that uses WebView.
	# TODO -> This minimizes the chances of bugs, especially if user doesnt have any browsers present in their device.

func _on_close_button_up() -> void:
	self.hide()

func _on_pfp_image_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	if response_code == 200:
		var image = Image.new()
		image.load_png_from_buffer(body)
		var texture = ImageTexture.create_from_image(image)
		user_pfp.texture = texture

	retrieve_pfp_signal.emit()

func _on_retrieve_username_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var retrieved_data = JSON.parse_string(body.get_string_from_utf8())

		Dialogic.VAR.user_var.username = retrieved_data.username
		Dialogic.VAR.user_var.gender = retrieved_data.gender

		Firebase.user_info.username = retrieved_data.username
		Firebase.user_info.gender = retrieved_data.gender
		user_info.token = Firebase.user_info.token
		user_info.refreshToken = Firebase.user_info.refreshToken
		user_info.id = Firebase.user_info.id
		user_info.username = retrieved_data.username
		user_info.gender = retrieved_data.gender

	retrieve_username_signal.emit()
