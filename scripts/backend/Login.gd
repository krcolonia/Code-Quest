extends CanvasLayer

# ? User Inputs
@onready var username = $InputCanvas/PageInputMargin/InputVBox/Username/LineEdit
@onready var password = $InputCanvas/PageInputMargin/InputVBox/Password/LineEdit

# ? Submit/Login Button
@onready var login_button = $InputCanvas/PageInputMargin/InputVBox/SubmitMargin/LoginButton

# ? Redirecto to Register Button
@onready var redirect_register_button = $InputCanvas/PageInputMargin/InputVBox/RedirectRegister/Button

var save_path = "user://user_info.save"

var email: String

func _ready() -> void:
	$InputCanvas/CanvasModulate.show()
	$AnimationPlayer.play("fade_in")

	AlertDialog.button1.pressed.connect(self._on_close_pressed)
	AlertDialog.set_button1_name("Close")

	AlertDialog.button2.pressed.connect(self._on_confirm_pressed)
	AlertDialog.set_button2_name("Confirm")

func _on_login_button_pressed():
	AlertDialog.hide_button1()
	AlertDialog.hide_button2()

	#region # ? Input Validation before sending Login request to Firebase
	if username.text.is_empty():
		AlertDialog.set_title("Input Invalid!")
		AlertDialog.set_message("Please enter your Username")

		AlertDialog.set_margin(420, 420)

		AlertDialog.show()
		return
	
	if password.text.is_empty():
		AlertDialog.set_title("Input Invalid!")
		AlertDialog.set_message("Please enter your Password")

		AlertDialog.set_margin(420, 420)

		AlertDialog.show()
		return
	#endregion

	#region # ? Request to get email from username via Firebase RDB
	var get_user_http = HTTPRequest.new()
	add_child(get_user_http)
	get_user_http.request_completed.connect(self._on_get_user_completed)
	Firebase.get_document("usernames/%s" % username.text,get_user_http)
	SceneManager.show_loading()

	await get_user_http.request_completed
	get_user_http.queue_free()
	#endregion

	#region # ? Login request sent to Firebase Authentication service
	var login_http = HTTPRequest.new()
	add_child(login_http)

	if _get_user_response:
		login_http.request_completed.connect(self._on_login_request_completed)
		
		Firebase.login(email, password.text, login_http)
		await login_http.request_completed
	login_http.queue_free()
	#endregion

	#region # ? Retrieve user info from 'users' table in Firebase RDB
	var get_info_http = HTTPRequest.new()
	add_child(get_info_http)
	
	if _login_response:
		get_info_http.request_completed.connect(self._on_get_info_completed)
		# ? Retrieve username from RDB
		Firebase.get_document("users/%s" % Firebase.user_info.id, get_info_http)
		await get_info_http.request_completed
	get_info_http.queue_free()
	#endregion

func _on_close_pressed():
	AlertDialog.close()

func _on_confirm_pressed():
	AlertDialog.close()

func _on_redirect_register_btn_button_up() -> void:
	SceneManager.change_menu(SceneManager.MENU_DICTIONARY["REGISTER_SCREEN"])

var logdate = {
	"last_login_date": {}
}

# ? REST API Request method used to send a REST API request to retrieve email from username
var _get_user_response: bool = false
func _on_get_user_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		if json == null: # ? If the username is not found, login will not continue.
			print("user not found")
			AlertDialog.set_title("Input Invalid!")
			AlertDialog.set_message("Username not found. Please enter your account's username!")

			AlertDialog.set_margin(420, 420)

			AlertDialog.show_button1()

			AlertDialog.show()
			SceneManager.reset_animplayer()
			return
		email = str(json)
		_get_user_response = true
		return
	else:
		AlertDialog.set_title("Error " + str(response_code))
		AlertDialog.set_message(json.error.message.capitalize())

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button1()
		AlertDialog.hide_button2()

		AlertDialog.show()
		SceneManager.reset_animplayer()
		return

# ? REST API Request method to login user via Firebase Authentication
var _login_response: bool = false
func _on_login_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		print("login successful")
		_login_response = true
		return
	else:
		AlertDialog.set_title("Error " + str(response_code))
		AlertDialog.set_message(json.error.message.capitalize())

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button1()
		AlertDialog.hide_button2()

		AlertDialog.show()
		SceneManager.reset_animplayer()
		return

var user_info: Dictionary = {
	"username": {},
	"gender": {},
	"token": {},
	"refreshToken": {},
	"id": {}
}

# ? REST API Request method to retrieve user information relevant to gameplay via Firebase RDB
func _on_get_info_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var retrieved_user = JSON.parse_string(body.get_string_from_utf8())

		Dialogic.VAR.user_var.username = retrieved_user.username
		Dialogic.VAR.user_var.gender = retrieved_user.gender

		Firebase.user_info.username = retrieved_user.username
		Firebase.user_info.gender = retrieved_user.gender

		user_info.username = retrieved_user.username
		user_info.gender = retrieved_user.gender

		logdate.last_login_date = Time.get_datetime_string_from_system(false, true)

		# ? Update Firebase login date.
		var update_db_http = HTTPRequest.new()
		add_child(update_db_http)
		update_db_http.request_completed.connect(self._on_realtime_db_request_completed)
		Firebase.update_document("users/%s" % Firebase.user_info.id, logdate, update_db_http)
		await update_db_http.request_completed
		update_db_http.queue_free()
	else:
		return

# ? REST API Request method used to update the login date found in 'users' table per user id
func _on_realtime_db_request_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if response_code == 200:
		var file
		if !FileAccess.file_exists(save_path):
			file = FileAccess.open(save_path, FileAccess.WRITE)
		else:
			file = FileAccess.open(save_path, FileAccess.READ_WRITE)

		user_info.token = Firebase.user_info.token
		user_info.refreshToken = Firebase.user_info.refreshToken
		user_info.id = Firebase.user_info.id

		file.store_var(user_info)

		file.close()
		SceneManager.reset_animplayer()

		AlertDialog.set_title("Login Successful")
		AlertDialog.set_message("Login Successful. Redirecting to Main Menu")

		AlertDialog.set_margin(380, 380)

		AlertDialog.hide_button1()
		AlertDialog.hide_button2()

		AlertDialog.show()

		SaveGameManager.load_save_details()
		print(SaveGameManager.data)

		await get_tree().create_timer(1.5).timeout

		AlertDialog.button1.pressed.disconnect(self._on_close_pressed)
		AlertDialog.button2.pressed.disconnect(self._on_confirm_pressed)
		
		AlertDialog.close()

		$AnimationPlayer.play("fade_out")
		await get_tree().create_timer(1.2).timeout
		SceneManager.change_menu(SceneManager.MENU_DICTIONARY["MAIN_MENU"])