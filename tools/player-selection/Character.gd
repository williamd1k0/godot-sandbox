extends Sprite

export(Color) var player_color = Color(1, 1, 1) setget set_player_color
export(bool) var multi_selectable = false
var player_focus = 0
var selected = false

func _ready():
	set_focus(false)

func grab_focus(p, color=null):
	player_focus = p
	if player_focus > 0:
		set_focus(true)
	if color == null:
		color = player_color
	set_player_color(color)

func blur():
	player_focus = 0
	set_focus(false)

func is_focused():
	return player_focus > 0

func can_focus():
	return not is_focused() or multi_selectable

func set_focus(b):
	get_material().set_shader_param("enabled", b)

func set_player_color(c):
	player_color = c
	get_material().set_shader_param("outline_color", c)
	
func get_focus_pos():
	return get_node("Focus").get_global_pos()
	
func set_selected(b):
	selected = b
	if selected:
		set_blend_mode(BLEND_MODE_ADD)
	else:
		set_blend_mode(BLEND_MODE_MIX)
