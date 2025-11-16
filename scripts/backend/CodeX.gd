extends Node

const EXEC_URL = "https://api.codex.jaagrav.in"

const AUTH_HEADERS := ["Content-Type: application/json"]

var script_result: String

func execute_code(script: String, stdin: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_execute_request_completed):
		http.request_completed.connect(_on_execute_request_completed)
	var body := {
		'code': script,
		'language': 'py',
		'input': stdin,
	}
	http.request(EXEC_URL, AUTH_HEADERS, HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_execute_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		script_result = json.output
	else:
		print("Response Code: " + str(response_code))
		print(json.error.message.capitalize())
		print(json)
