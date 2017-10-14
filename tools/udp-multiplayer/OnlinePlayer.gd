extends Sprite

var player = -1
var local = false
var udp
var last_pos = Vector2(0, 0)

func _ready():
	last_pos = get_global_pos()

func _process(delta):
	if local:
		set_global_pos(get_global_mouse_pos())
		if get_global_pos() != last_pos:
			last_pos = get_global_pos()
			udp.put_var(['pos', {"player": player, "pos": last_pos}])

func new_message(args):
	if 'pos' in args:
		set_global_pos(args[1]['pos'])

func enable_player(data, local_, udp_, color=null):
	player = data['player']
	set_modulate(data['color'])
	local = local_
	udp = udp_
	set_process(local_)
