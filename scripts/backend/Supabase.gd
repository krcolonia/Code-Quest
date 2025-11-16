extends Node

# ? this project originally used firebase as it's backend, but due to google being increasingly annoying by the minute,
# ? i've decided to completely rewrite the backend using supabase. we used to have a good thing google, why ruin it??? -krColonia

# ? this supabase class is based entirely off of the API documentation, and the supabase addon for godot made by fenix. I
# ? was originally supposed to use that instead of coding my own implementation, but I was having problems with how the addon is setup.

const ENVIRONMENT_VARIABLES : String = 'supabase/config'
var config: Dictionary = {
	'supabaseUrl': '',
	'supabaseKey': ''
}

func _ready() -> void:
	if config.supabaseKey != "" and config.supabaseUrl != "":
		pass
	else:
		var env = ConfigFile.new()
		var err = env.load("res://.env")
		if err == OK:
			for key in config.keys():
				var value: String = env.get_value(ENVIRONMENT_VARIABLES, key, '')
				if value == '':
					printerr('%s has an invalid value.' % key)
				else:
					config[key] = value
	pass

func _get_request_headers() -> PackedStringArray:
	return PackedStringArray([
		"Content Type: application/json",
		"Accept: application/json",
		"apikey: %s" % config.supabaseKey
	])

# ? Authentication
#region
const _auth_endpoint := '/auth/v1'
const _signup := _auth_endpoint+'/signup'
const _signin := _auth_endpoint+'/token?grant_type=password'
const _reset_password := _auth_endpoint+'/recover'
const _logout := _auth_endpoint+'/logout'
const _user := _auth_endpoint+'/user'

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
	http.request(config.supabaseUrl + _signup, _get_request_headers(), HTTPClient.METHOD_POST, JSON.stringify(body))

func sign_in(email: String, password:String, http: HTTPRequest) -> void:
	if !http.is_connected('request_completed', _on_auth_request_completed):
		http.request_compelted.connect(_on_auth_request_completed)
	var body := {
		'email': email,
		'password': password,
	}
	http.request(config.supabaseUrl + _signin, _get_request_headers(), HTTPClient.METHOD_POST, JSON.stringify(body))

signal auth_request_signal

func _on_auth_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		pass
	else:
		print('Response Code' + str(response_code))
		print(json.msg.capitalize())
	auth_request_signal.emit()
#endregion

