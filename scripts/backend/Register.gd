extends CanvasLayer

# ? User Input Nodes
@onready var gender = $InputCanvas/PageInputMargin/InputVBox/InputScroll/ScrollMainContainer/ScrollContainer1/GenderMargin/GenderHBox/OptionButton
@onready var email = $InputCanvas/PageInputMargin/InputVBox/InputScroll/ScrollMainContainer/ScrollContainer2/Email/LineEdit

@onready var username = $InputCanvas/PageInputMargin/InputVBox/InputScroll/ScrollMainContainer/ScrollContainer1/Username/LineEdit
@onready var password = $InputCanvas/PageInputMargin/InputVBox/InputScroll/ScrollMainContainer/ScrollContainer2/Password/LineEdit
@onready var confirm_pass = $InputCanvas/PageInputMargin/InputVBox/InputScroll/ScrollMainContainer/ScrollContainer2/ConfirmPassword/LineEdit

# ? Submit/Register Button Node
@onready var reg_button = $InputCanvas/PageInputMargin/InputVBox/SubmitMargin/RegisterButton

# ? Redirect to Login Button Node
@onready var redirect_login_btn = $InputCanvas/PageInputMargin/InputVBox/RedirectLogin/Button

var profile := {
	"gender": {},
	"username": {},
	"date_registered": {}
}

var selected_gender: String = "Male"

func _ready():
	$InputCanvas/CanvasModulate.show()
	$AnimationPlayer.play("fade_in")
	
	AlertDialog.button1.pressed.connect(self._on_close_pressed)
	AlertDialog.button2.pressed.connect(self._on_confirm_pressed)

	AlertDialog.set_button1_name("Close")
	AlertDialog.set_button2_name("Confirm")

	AlertDialog.hide_button1()
	AlertDialog.hide_button2()

func _on_redirect_login_button_up() -> void:
	SceneManager.change_menu(SceneManager.MENU_DICTIONARY["LOGIN_SCREEN"])

func _on_gender_selected(index:int) -> void:
	match index:
		0: # ? Male
			selected_gender = 'Male'
		1: # ? Female
			selected_gender = 'Female'

func _on_register_button_pressed():	
	#region # ? Input Validations before sending API Register Request
	if email.text.is_empty():
		AlertDialog.set_title("Input Invalid!")
		AlertDialog.set_message("Please enter your E-mail Address")

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button2()

		AlertDialog.show()
		return

	if username.text.is_empty():
		AlertDialog.set_title("Input Invalid!")
		AlertDialog.set_message("Please enter your Username")

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button2()

		AlertDialog.show()
		return
	
	if password.text.is_empty():
		AlertDialog.set_title("Input Invalid!")
		AlertDialog.set_message("Please enter a password for your account")

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button2()

		AlertDialog.show()
		return
	
	if password.text != confirm_pass.text:
		AlertDialog.set_title("Input Invalid!")
		AlertDialog.set_message("Passwords do not match")

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button2()

		AlertDialog.show()
		return
	
	if !AlertDialog.check_input.is_pressed():
		AlertDialog.set_title("Privacy Policy")
		AlertDialog.show_scroll_message()

		AlertDialog.set_margin(45, 45)

		AlertDialog.show_check()

		AlertDialog.show_button1()

		AlertDialog.show()
		return
	#endregion

func _on_close_pressed():
	AlertDialog.close()
	AlertDialog.hide_button1()
	AlertDialog.hide_button2()

	if !AlertDialog.check_input.is_pressed():
		return
	
	AlertDialog.check_input.set_pressed(false)

	#region # ? Check if username has already been used by a previously registered account
	var check_http = HTTPRequest.new()
	add_child(check_http)
	check_http.request_completed.connect(_on_check_usernames_request_completed)
	Firebase.get_document("usernames", check_http)
	SceneManager.show_loading()

	await check_http.request_completed
	check_http.queue_free()
	#endregion

	#region # ? Register user using provided inputs to Firebase Authentication
	var auth_http = HTTPRequest.new()
	add_child(auth_http)

	if _check_response:
		auth_http.request_completed.connect(_on_authentication_request_completed)

		Firebase.register(email.text, password.text, auth_http)
		await auth_http.request_completed
	auth_http.queue_free()
	#endregion

	#region # ? Add User Information to 'users' table in Firebase RDB
	var add_user_http = HTTPRequest.new()
	add_child(add_user_http)

	if _register_response:
		add_user_http.request_completed.connect(_on_user_added_completed)

		Firebase.update_document("users/%s" % Firebase.user_info.id, profile, add_user_http)
		await add_user_http.request_completed
	add_user_http.queue_free()
	#endregion

	#region # ? Add player to leaderboards
	var add_leaderboard_http = HTTPRequest.new()
	add_child(add_leaderboard_http)

	if _user_add_response:
		add_leaderboard_http.request_completed.connect(_on_leaderboard_added_completed)

		Firebase.update_document("leaderboards/%s" % Firebase.user_info.id, { "points": 0, "username": username.text }, add_leaderboard_http)
		await add_leaderboard_http.request_completed
	add_leaderboard_http.queue_free()
	#endregion

	#region # ? Add user's username to 'usernames' table, storing their email alongside their username
	var add_username_http = HTTPRequest.new()
	add_child(add_username_http)
	
	if _leaderboards_response:
		add_username_http.request_completed.connect(_on_username_added_completed)

		Firebase.update_document("usernames", { username.text: email.text }, add_username_http)
		await add_username_http.request_completed
	add_username_http.queue_free()
	#endregion



func _on_confirm_pressed():
	AlertDialog.close()
	AlertDialog.hide_button1()
	AlertDialog.hide_button2()

var _check_response: bool = false
func _on_check_usernames_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		if json.has(username.text): # ? if the username is found in the database, register will not push through
			print("username found in db")
			AlertDialog.set_title("Input Invalid!")
			AlertDialog.set_message("Username is already in use! Please choose another username.")

			AlertDialog.set_margin(420, 420)

			AlertDialog.show_button2()

			AlertDialog.show()
			SceneManager.reset_animplayer()
			return	 
		print("username not found in db success")
		_check_response = true
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

var _register_response: bool = false
func _on_authentication_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		profile.username = username.text
		profile.gender = selected_gender
		profile.date_registered = Time.get_datetime_string_from_system(false, true)

		_register_response = true
	else:
		SceneManager.reset_animplayer()
		AlertDialog.set_title("Error " + str(response_code))
		AlertDialog.set_message(json.error.message.capitalize())

		AlertDialog.set_margin(420, 420)

		AlertDialog.show_button2()

		AlertDialog.show()

var _user_add_response: bool = false
func _on_user_added_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if response_code == 200:
		_user_add_response = true
	else:
		return

var _leaderboards_response: bool = false
func _on_leaderboard_added_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if response_code == 200:
		_leaderboards_response = true
	else:
		return

func _on_username_added_completed(_result: int, response_code: int, _headers: PackedStringArray, _body:PackedByteArray) -> void:
	if response_code == 200:
		SceneManager.reset_animplayer()
		AlertDialog.set_title("Registration Successful")
		AlertDialog.set_message("You may now continue to login your account")

		AlertDialog.set_margin(380, 380)

		AlertDialog.hide_button1()
		AlertDialog.hide_button2()

		AlertDialog.show()
		await get_tree().create_timer(1.5).timeout

		AlertDialog.button1.pressed.disconnect(self._on_close_pressed)
		AlertDialog.button2.pressed.disconnect(self._on_confirm_pressed)
		
		AlertDialog.close()

		$AnimationPlayer.play("fade_out")
		await get_tree().create_timer(1.2).timeout
		SceneManager.change_menu(SceneManager.MENU_DICTIONARY["LOGIN_SCREEN"])
