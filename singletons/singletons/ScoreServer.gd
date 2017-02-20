extends Node

const TOKEN = 'TOTALLY-SECRET-TOKEN'
const HOST = 'http://127.0.0.1'
const PORT = 80
const CHECK_ROUTE = '/gamesample/'
const HEADERS = [
    "User-Agent: Godot/2.1.2",
    "Accept: */*"
]
const DEFAULT_METHOD = HTTPClient.METHOD_GET

var http = HTTPRequest.new()
var timer = Timer.new()
	
func _ready():
	add_child(http)
	add_child(timer)
	http.connect("request_completed", self, '_on_request_completed')
	timer.connect("timeout", self, '_on_connection_timeout')
	check_connection()

func check_connection():
	print('CHECKING CONNECTION')
	request(CHECK_ROUTE)

func request(route, timeout=5):
	http.cancel_request()
	http.request(parse_route(route), HEADERS, true, DEFAULT_METHOD)
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
	assert(result == HTTPRequest.RESULT_SUCCESS)
	assert(response_code == 200)
	print(headers)
	print(body.get_string_from_utf8())
