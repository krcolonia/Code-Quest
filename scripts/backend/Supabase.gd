extends Node

# ? this project originally used firebase as it's backend, but due to google being increasingly annoying by the minute,
# ? i've decided to completely rewrite the backend using supabase. we used to have a good thing google, why ruin it??? -krColonia

# ? this supabase class is based entirely off of the API documentation, and the supabase addon for godot made by fenix. I
# ? was originally supposed to use that instead of coding my own implementation, but I was having problems with how the addon is setup.

const config = {
	'supabaseUrl': '',
	'supabaseKey': ''
}

const _auth_endpoint := '/auth/v1'
const _signup_endpoint := _auth_endpoint+'/signup'

func _get_request_headers() -> PackedStringArray:
	return PackedStringArray([
		"Content Type: application/json",
		"Accept: application/json",
		"Authorization: Bearer %s" % config.supabaseKey,
		"apikey: %s" % config.supabaseKey
	])

func sign_up(email: String, password: String, username: String, http: HTTPRequest) -> void:
	if !http.is_connected('request_completed', _on_auth_request_completed):
		http.request_completed.connect(_on_auth_request_completed)
	var body := {
		'email': email,
		'password': password,
		'data': {
			'username': username
		}
	}
	http.request(config.supabaseUrl + _signup_endpoint, _get_request_headers(), HTTPClient.METHOD_POST, JSON.stringify(body))

signal auth_request_signal

func _on_auth_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		pass
	else:
		print('Response Code' + str(response_code))
		print(json.msg.capitalize())
	auth_request_signal.emit()
