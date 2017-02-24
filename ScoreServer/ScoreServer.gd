extends Node

signal request_complete(data, code)
signal request_error(response, error)

const RESPONSE_UTF8_STR = 0
const RESPONSE_ASCII_STR = 1
const RESPONSE_JSON_DICT = 2
const HEADERS = [
    "User-Agent: Godot/2.1.2",
    "Accept: */*"
]

export var TOKEN = 'TOTALLY-SECRET-TOKEN'
export var HOST = 'http://127.0.0.1'
export(int, 65535) var PORT = 80
export var init_check = true
export var CHECK_ROUTE = '/'
export(int, 'GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'OPTIONS') var DEFAULT_METHOD = 0
export(int, 'UTF8-String', 'ASCII-String', 'JSON-Dict') var response_data

# METHOD_GET = 0
# METHOD_HEAD = 1
# METHOD_POST = 2
# METHOD_PUT = 3
# METHOD_DELETE = 4
# METHOD_OPTIONS = 5

var client = HTTPClient.new()
var http = HTTPRequest.new()
var timer = Timer.new()

func _ready():
	add_child(http)
	add_child(timer)
	http.connect("request_completed", self, '_on_request_completed')
	timer.connect("timeout", self, '_on_connection_timeout')
	if init_check:
		check_connection()

func check_connection():
	print('CHECKING CONNECTION')
	request(CHECK_ROUTE, {'token': TOKEN})


func request(route, query={}, timeout=5):
	var query_data = client.query_string_from_dict(query)
	http.cancel_request()
	if DEFAULT_METHOD == HTTPClient.METHOD_GET:
		http.request(parse_route(route)+'?'+query_data, HEADERS, true, DEFAULT_METHOD)
	else:
		http.request(parse_route(route), HEADERS, true, DEFAULT_METHOD, query_data)
	timer.set_wait_time(timeout)
	timer.start()

func parse_route(route):
	return HOST+':'+str(PORT)+route

func _on_connection_timeout():
	print('CONNECTION PROBLEM')
	http.cancel_request()

func _on_request_completed(result, response_code, headers, body):
	print("REQUEST COMPLETED")
	timer.stop()
	print(response_code)
	print(headers)
	print(body.get_string_from_utf8())
	if response_code >= 400 or result != HTTPRequest.RESULT_SUCCESS: 
		emit_signal('request_error', body, response_code)
	
	var response
	if response_data == RESPONSE_UTF8_STR:
		response = body.get_string_from_utf8()
	elif response_data == RESPONSE_ASCII_STR:
		response = body.get_string_from_ascii()
	elif response_data == RESPONSE_JSON_DICT:
		response = Dictionary()
		response.parse_json(body.get_string_from_utf8())
	print(response)
	emit_signal('request_complete', response, response_code)

