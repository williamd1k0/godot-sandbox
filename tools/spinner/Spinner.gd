extends Area2D

signal spin
signal stop

export(int) var duration_exp = 1
onready var area = get_node('Area')
var torque_dump = 0.9
var torque = 0
var held = false
var clockwise = 0
var temp_add_rot = 0


var mouse_speed = 0
var mouse_last_pos = Vector2()
var mouse_timer = 0

# Angular velocity
var last_ang = 0
var total_rot = 0
var rpm = 0


func _ready():
	connect("input_event", self, "_on_input_event")
	torque_dump = 1 - pow(10, -duration_exp)
	set_process(true)
	set_process_input(true)
	
func _input(event):
	if event.is_action_released('lmb') and held:
		held = false
		spin(mouse_speed/2)

func _process(delta):
	mouse_timer += delta
	if mouse_timer > 0.2:
		mouse_speed = (
			mouse_speed + mouse_last_pos.distance_to(get_global_mouse_pos())
		) /2
		mouse_last_pos = get_global_mouse_pos()
		mouse_timer = 0
	if held:
		point()
	else:
		if torque > 0.05:
			var new_rot = area.get_rot()
			new_rot -= torque * delta * clockwise
			torque *= torque_dump
			rpm = int(angular_velocity_frequency(last_ang - new_rot, delta))
			if new_rot >= total_rot * 2*PI:
				total_rot += 1
			last_ang = new_rot
			area.set_rot(new_rot)
		else:
			emit_signal("stop")
			total_rot = 0
			last_ang = 0
			torque = 0

func angular_velocity_frequency(delta_teta, delta_t, freq=60):
	return abs(delta_teta * (freq/delta_t)) # rads/60s | RPM


func point():
	var rot = area.get_rot()
	area.set_rot(
		area.get_pos().angle_to_point(get_local_mouse_pos()) + temp_add_rot
	)
	clockwise = 1 if rot > area.get_rot() else -1

func spin(amt):
	emit_signal("spin")
	torque += amt

func _on_input_event( viewport, event, shape_idx ):
	if event.is_action('lmb'):
		emit_signal("stop")
		held = event.is_action_pressed('lmb')
		torque = 0
		temp_add_rot = area.get_rot() - area.get_pos().angle_to_point(
			get_local_mouse_pos()
		)
