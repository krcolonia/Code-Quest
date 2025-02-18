extends Node

# ? This class is autoloaded, meaning that it runs in the background of whichever scene
# ? we are in the game. This is made so that we could access all these functions anytime.
# * - krColonia

# ! Firebase API URLs for HTTP Requests
# ! CANNOT BE USED WITHOUT API KEYS, WHICH ARE PRIVATE
const REGISTER_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % ApiKey.FIREBASE_KEY
const LOGIN_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % ApiKey.FIREBASE_KEY
const REFRESH_URL := "https://securetoken.googleapis.com/v1/token?key=%s" % ApiKey.FIREBASE_KEY
const DB_URL := "https://code-quest-pytome-default-rtdb.firebaseio.com/"
const STRG_URL := "https://firebasestorage.googleapis.com/v0/b/code-quest-pytome.appspot.com"


# ! Variable for storing user information (Token, Refresh Token, User ID, Username)
var user_info: Dictionary

# ? The following functions make use of Godot's HTTPRequest node
# ? Basically, an HTTPRequest is equivalent to JavaScript's 'fetch()' function
# ? Where you can make HTTP Requests to links, most of which are APIs 
# * - krColonia

# ? The functions below make use of Firebase's RESTful APIs, the links of which can be found above
# ? This allows us to manage all back-end related things such as the database and cloud storage
# ? Through APIs, lessening the load on the app and the user's device. This however, makes use of
# ? internet connection, which is why we made it a strict requirement to have access to stable connection
# * - krColonia

const USER_DATA_PATH: String = "user://user_info.save"
func user_exists() -> bool:
	return FileAccess.file_exists(USER_DATA_PATH)

#region # ! Get functions used when retrieving information from this class to other classes
func _get_token_id_from_result(result: PackedByteArray) -> String:
	var result_body = JSON.parse_string(result.get_string_from_utf8())
	return result_body.idToken

func _get_user_info(result: PackedByteArray) -> Dictionary:
	var result_body = JSON.parse_string(result.get_string_from_utf8())
	return {
		"token": result_body.idToken,
		"refreshToken": result_body.refreshToken,
		"id": result_body.localId
	}

func _get_refreshed_token(result: PackedByteArray) -> Dictionary:
	var result_body = JSON.parse_string(result.get_string_from_utf8())
	return {
		"token": result_body.id_token,
		"refreshToken": result_body.refresh_token,
		"id": result_body.user_id
	}

func _get_request_headers() -> PackedStringArray:
	return PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])
#endregion

#region # ! Firebase Authentication REST API call functions
# ? Function that registers user to Firebase Auth using email and password
func register(email: String, password: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_auth_request_completed):
		http.request_completed.connect(_on_auth_request_completed)
	var body := {
		"email": email,
		"password": password
	}
	http.request(REGISTER_URL, [], HTTPClient.METHOD_POST, JSON.stringify(body))

# ? Function that logs in registered users to Firebase Auth using email and password
func login(email: String, password: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_auth_request_completed):
		http.request_completed.connect(_on_auth_request_completed)
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	http.request(LOGIN_URL, [], HTTPClient.METHOD_POST, JSON.stringify(body))

signal auth_request_signal

func _on_auth_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		user_info = _get_user_info(body)
	else:
		print("Response Code: " + str(response_code))
		print(json.error.message.capitalize())
	auth_request_signal.emit()

# ? Function to refresh Firebase authentication token
func refresh_token(ref_token: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_refresh_request_completed):
		http.request_completed.connect(_on_refresh_request_completed)
	var body := {
		"grant_type": "refresh_token",
		"refresh_token": ref_token,
	}
	http.request(REFRESH_URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_refresh_request_completed(_result: int, response_code: int, _headers:PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		user_info = _get_refreshed_token(body)
	else:
		print("Response Code: " + str(response_code))
		print(json.error.message.capitalize())
#endregion

#region # ! Firebase Realtime Database REST API call Functions
# ? Function that saves passed data to document under user UID
func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_create_completed):
		http.request_completed.connect(_on_db_create_completed)
	var url: String = DB_URL + path + ".json?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_PUT, str(fields))

func _on_db_create_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("RDB Create Document Response: " + str(response_code))

# ? Function that gets all data from document under user UID
func get_document(path: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_read_completed):
		http.request_completed.connect(_on_db_read_completed)
	var url: String = DB_URL + path + ".json" # ?auth=%s" % user_info.token
	http.request(url, [], HTTPClient.METHOD_GET)

func _on_db_read_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("RDB Get Document Response: " + str(response_code))

# ? Function that updates specified data in document under user UID
func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_update_completed):
		http.request_completed.connect(_on_db_update_completed)
	var url: String = DB_URL + path + ".json?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_PATCH, str(fields))
	await http.request_completed
	http.request_completed.disconnect(_on_db_update_completed)

func _on_db_update_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("RDB Update Document Response: " + str(response_code))

# ? Function that deletes specified data in document under user UID
func delete_document(path: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_delete_completed):
		http.request_completed.connect(_on_db_delete_completed)
	var url: String = DB_URL + path + ".json?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_DELETE)

func _on_db_delete_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("RDB Delete Document Response: " + str(response_code))

# ? Function that gets user data from document under user UID
func get_user_profile(path: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_get_user_profile_completed):
		http.request_completed.connect(_on_get_user_profile_completed)
	var url: String = DB_URL + path + ".json?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_GET)

func _on_get_user_profile_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("Get User Document Response: " + str(response_code))

func get_leaderboards(http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_get_leaderboards_completed):
		http.request_completed.connect(_on_get_leaderboards_completed)
	var url: String = DB_URL + 'leaderboards.json?auth=%s' % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_GET)
	

func _on_get_leaderboards_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("Get Leaderboards Response: " + str(response_code))

# ? Function used to retrieve images from Firbase Storage
func get_profile_pic(http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_storage_request_completed):
		http.request_completed.connect(_on_storage_request_completed)
	var url: String = STRG_URL + "/o/user-profile%2F" + user_info.id + ".png?alt=media"
	http.request(url, _get_request_headers(), HTTPClient.METHOD_GET)

func _on_storage_request_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("Storage Request Response: " + str(response_code))
#endregion

#region # ! Functions used to test connection with Firebase
func test_connection(http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_test_connection_completed):
		http.request_completed.connect(_on_test_connection_completed)
	var url: String = DB_URL + "test_connection.json"
	http.request(url, [], HTTPClient.METHOD_GET)

func _on_test_connection_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	print("Test Internet Response: " + str(response_code))
#endregion