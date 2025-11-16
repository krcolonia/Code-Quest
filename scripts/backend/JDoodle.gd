extends Node

# ? JDoodle requires a subscription, so I don't really wanna use this
# ? If the CodeX API goes online again, I'll choose that over JDoodle.

const EXEC_URL := "https://api.jdoodle.com/v1/execute"
const CREDIT_URL := "https://api.jdoodle.com/v1/credit-spent"

const AUTH_HEADERS := ["Content-Type: application/json"]

var spent_creds: int
const total_creds: int = 220

var script_result: String

#region Preparing API Call Functions
func execute_code(script: String, stdin: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_execute_request_completed):
		http.request_completed.connect(_on_execute_request_completed)
	var body: Dictionary = {
		'clientId': ApiKey.JDOODLE_ID,
		'clientSecret': ApiKey.JDOODLE_SECRET,
		'script': script,
		'stdin': stdin,
		'language': 'python3',
		'versionIndex': 5
	}
	http.request(EXEC_URL, AUTH_HEADERS, HTTPClient.METHOD_POST, JSON.stringify(body))

func get_spent_credits(http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_credit_request_completed):
		http.request_completed.connect(_on_credit_request_completed)
	var body := {
		'clientId': ApiKey.JDOODLE_ID,
		'clientSecret': ApiKey.JDOODLE_SECRET
	}
	http.request(CREDIT_URL, AUTH_HEADERS, HTTPClient.METHOD_POST, JSON.stringify(body))
#endregion

#region HTTP Requests Completed Functions
func _on_execute_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		script_result = json.output
	else:
		print("Response Code: " + str(response_code))
		print(json.error.capitalize())

func _on_credit_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		spent_creds = int(json.used)
		print("\nSpent Credits: " + str(spent_creds))
		print("Remaining Credits: " + str(total_creds - spent_creds) + "\n")
	else:
		print("Response Code: " + str(response_code))
		print(json.error.capitalize())
#endregion
