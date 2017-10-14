extends Node

const PLAYER = preload("OnlinePlayer.tscn")
onready var player_container = get_node("Players")
var server_host = 'localhost'
var server_port = 5000
var valid_ports = [5001, 5002, 5003]
var udp = PacketPeerUDP.new()
var clients = {}
var server = false
var players = []

func _ready():
	OS.set_window_size(Vector2(200, 160))
	randomize()
	var args = OS.get_cmdline_args()
	if 'server' in args:
		run_server()
	else:
		run_client()

func run_client():
	for port_try in valid_ports:
		var err = udp.listen(port_try)
		if err == OK:
			print('CLIENT >ON<')
			udp.set_send_address(server_host, server_port)
			udp.put_var(['new'])
			set_process(true)
			break

func run_server():
	var err = udp.listen(server_port)
	if err == OK:
		print('SERVER >ON<')
		print('SERVER: ', server_host, ':', server_port)
		server = true
		set_process(true)
		get_node("Info").add_text('SERVER ON')

func _process(delta):
	if not udp.is_listening():
		return
	if server:
		server_process(delta)
	else:
		client_process(delta)

func server_process(delta):
	while(udp.get_available_packet_count() > 0):
		var data = udp.get_var()
		if 'new' in data:
			var host = udp.get_packet_ip()
			var port = udp.get_packet_port()
			if not '%s:%s' % [host, port] in clients:
				clients['%s:%s' % [host, port]] = [host, port]
				players.append({
					'player': players.size(),
					'color': Color(randf(), randf(), randf())
				})
				print('NEW CLIENT: ', host, ':', port)
				get_node("Info").add_text('\nPlayer %s - Connected' % players.size())
				for c in clients:
					udp.set_send_address(clients[c][0], clients[c][1])
					udp.put_var(['init', players])
		else:
			var i = 0
			for c in clients:
				if data[1]['player'] != i:
					udp.set_send_address(clients[c][0], clients[c][1])
					udp.put_var(data)
				i += 1

func client_process(delta):
	while(udp.get_available_packet_count() > 0):
		var data = udp.get_var()
		if 'init' in data:
			if player_container.get_child_count() == 0:
				for i in range(data[1].size()):
					var p = PLAYER.instance()
					player_container.add_child(p)
					p.enable_player(data[1][i], i == data[1][-1]['player'], udp)
			else:
				var p = PLAYER.instance()
				player_container.add_child(p)
				p.enable_player(data[1][-1], false, udp)
		else:
			for child in player_container.get_children():
				if data[1]['player'] == child.player:
					child.new_message(data)
					break
