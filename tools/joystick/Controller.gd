extends Node2D

signal connection_changed(connected)

export(int) var joy_num = 0

onready var l_axis = get_node("axes/left")
onready var r_axis = get_node("axes/right")

var axis_value


func _ready():
	set_process(true)
	set_joystick_connected(Input.get_connected_joysticks().size() >= joy_num+1)
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func set_joystick_connected(connected):
	if connected:
		set_opacity(1.0)
	else:
		set_opacity(0.5)
	emit_signal('connection_changed', connected)

func _process(delta):
	for axis in range(JOY_ANALOG_0_X, JOY_AXIS_MAX):
		axis_value = Input.get_joy_axis(joy_num, axis)
		if axis <= JOY_ANALOG_0_Y:
			if axis == JOY_ANALOG_0_X:
				l_axis.set_rot(-axis_value/4)
			else:
				l_axis.set_scale(Vector2(1, (axis_value+2)/3))
		elif axis <= JOY_ANALOG_1_Y:
			if axis == JOY_ANALOG_1_X:
				r_axis.set_rot(-axis_value/4)
			else:
				r_axis.set_scale(Vector2(1, (axis_value+2)/3))
		elif axis in [JOY_AXIS_6, JOY_AXIS_7]:
			get_node("buttons/trigger/" + str(axis)).show()
			get_node("buttons/trigger/" + str(axis)).set_opacity(abs(axis_value))

	for btn in range(JOY_BUTTON_0, JOY_BUTTON_MAX):
		var path = 'buttons/'
		if (Input.is_joy_button_pressed(joy_num, btn)):
			if btn in range(12, 16):
				get_node("buttons/dpad/" + str(btn)).show()
			elif btn == 8:
				get_node("axes/left").set_blend_mode(BLEND_MODE_ADD)
			elif btn == 9:
				get_node("axes/right").set_blend_mode(BLEND_MODE_ADD)
			else:
				if btn in range(4):
					path = "buttons/xyab/"
				elif btn in range(4, 6):
					path = "buttons/bumper/"
				elif btn in range(6, 8):
					path = "buttons/trigger/"
				elif btn in range(10, 12):
					path = "buttons/misc/"
				get_node(path + str(btn)).set_blend_mode(BLEND_MODE_ADD)
		else:
			if btn in range(12, 16):
				get_node("buttons/dpad/" + str(btn)).hide()
			elif btn == 8:
				get_node("axes/left").set_blend_mode(BLEND_MODE_MIX)
			elif btn == 9:
				get_node("axes/right").set_blend_mode(BLEND_MODE_MIX)
			elif not btn in [JOY_AXIS_6, JOY_AXIS_7]:
				if btn in range(4):
					path = "buttons/xyab/"
				elif btn in range(4, 6):
					path = "buttons/bumper/"
				elif btn in range(10, 12):
					path = "buttons/misc/"
				get_node(path + str(btn)).set_blend_mode(BLEND_MODE_MIX)


func _on_joy_connection_changed(device_id, connected):
	if device_id == joy_num:
		set_joystick_connected(connected)
