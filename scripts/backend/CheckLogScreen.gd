extends CanvasLayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var check_label: Label = $BGCanvasLayer/Panel/MarginContainer/Label

@onready var internet_check_http: HTTPRequest = $CheckInternet
signal internet_check_signal

@onready var refresh_token_http: HTTPRequest = $RefreshToken
signal refresh_token_signal

@onready var username_http: HTTPRequest = $RetrieveUsername
signal get_username_signal

@onready var validate_http: HTTPRequest = $CheckIDToken

var has_connection: bool

var user_info: Dictionary

var logdate: Dictionary = {
	"last_login_date": {}
}

var save_path: String = "user://user_info.save"

func _ready() -> void:
	validate_http.request_completed.connect(_on_token_check_completed)
	internet_check_http.request_completed.connect(_on_internet_check_completed)
	refresh_token_http.request_completed.connect(_on_refresh_token_completed)
	username_http.request_completed.connect(_on_retrieve_username_completed)

	AlertDialog.button1.pressed.connect(self._on_retry_pressed)
	AlertDialog.button2.pressed.connect(self._on_quit_pressed)

	check_functionality()

func check_functionality():
	check_internet_connection()
	
	await internet_check_signal

	if has_connection:
		anim_player.stop()

		anim_player.play("checking_account")
		await get_tree().create_timer(2.5).timeout

		if Firebase.user_exists():
			Firebase.user_info = FileAccess.open(save_path, FileAccess.READ).get_var()

			Firebase.refresh_token(Firebase.user_info.refreshToken, refresh_token_http)
			var refresh_response = await refresh_token_signal

			if refresh_response == 200:
				Firebase.get_document("users/%s" % Firebase.user_info.id, username_http)
				await get_username_signal

				var file: FileAccess
				if !FileAccess.file_exists(save_path):
					file = FileAccess.open(save_path, FileAccess.WRITE)
				else:
					file = FileAccess.open(save_path, FileAccess.READ_WRITE)

				user_info.token = Firebase.user_info.token
				user_info.refreshToken = Firebase.user_info.refreshToken
				user_info.id = Firebase.user_info.id

				file.store_var(user_info)

				file.close()

				logdate.last_login_date = Time.get_datetime_string_from_system(false, true)

				Firebase.update_document("users/%s" % Firebase.user_info.id, logdate, validate_http)
				SaveGameManager.load_save_details()
			else:
				if FileAccess.file_exists("user://save_data.save"):
					DirAccess.remove_absolute("user://save_data.save")

				if FileAccess.file_exists("user://user_info.save"):
					DirAccess.remove_absolute("user://user_info.save")

				user_not_found()
		else:
			user_not_found()
	else:
		anim_player.stop()

		AlertDialog.set_title("Error")
		AlertDialog.set_message("No Internet Connection found. Retry connection or close the game?")
		
		AlertDialog.set_margin(420, 420)
		
		AlertDialog.show_button1()
		AlertDialog.set_button1_name("Retry")
		
		AlertDialog.show_button2()
		AlertDialog.set_button2_name("Quit")

		AlertDialog.show()

func check_internet_connection():
	anim_player.play("checking_connection")
	Firebase.test_connection(internet_check_http)

func _on_internet_check_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var test_success = body.get_string_from_utf8()
		if test_success == "true":
			has_connection = true
	else:
		has_connection = false
	internet_check_signal.emit()

func _on_refresh_token_completed(_result: int, response_code: int, _headers:PackedStringArray, _body: PackedByteArray) -> void:
	if response_code == 200:
		pass
	refresh_token_signal.emit(response_code)

func _on_retrieve_username_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var retrieved_user = JSON.parse_string(body.get_string_from_utf8())

		Dialogic.VAR.user_var.username = retrieved_user.username
		Dialogic.VAR.user_var.gender = retrieved_user.gender

		Firebase.user_info.username = retrieved_user.username
		Firebase.user_info.gender = retrieved_user.gender

		user_info.username = retrieved_user.username
		user_info.gender = retrieved_user.gender
	
	get_username_signal.emit()
		
func _on_token_check_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	if response_code == 200:
		user_found()
	else:
		user_not_found()

func _on_retry_pressed():
	AlertDialog.close()
	check_functionality()

func _on_quit_pressed():
	get_tree().quit()

func user_found() -> void:
	anim_player.stop()
	check_label.text = "User found! Redirecting to Main Menu..."

	AlertDialog.button1.pressed.disconnect(self._on_retry_pressed)
	AlertDialog.button2.pressed.disconnect(self._on_quit_pressed)

	await get_tree().create_timer(2.5).timeout
	SceneManager.change_menu(SceneManager.MENU_DICTIONARY["MAIN_MENU"])

func user_not_found() -> void:
	anim_player.stop()
	check_label.text = "User not found. Redirecting to Login..."

	AlertDialog.button1.pressed.disconnect(self._on_retry_pressed)
	AlertDialog.button2.pressed.disconnect(self._on_quit_pressed)

	await get_tree().create_timer(2.5).timeout
	SceneManager.change_menu(SceneManager.MENU_DICTIONARY["LOGIN_SCREEN"])
