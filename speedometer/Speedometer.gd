extends Node2D

export(float) var max_speed = 200
export(String, 'Km/h', 'MPH') var unit = 'Km/h'
export(float) var speed = 0 setget set_speed
onready var needle = get_node("Needle")
onready var speed_label = get_node("Speed")
var zero_rad = 0
var max_rad = 0

func _ready():
	var needle_pos = needle.get_pos()
	zero_rad = needle_pos.angle_to_point(get_node("Zero").get_pos())
	max_rad = needle_pos.angle_to_point(get_node("Max").get_pos())
	reset()

func reset():
	get_node("MaxSpeed").set_text("%s%s" % [max_speed, unit])
	speed = 0
	update_speed()
	
func set_speed(sp):
	speed = clamp(sp, 0, max_speed)
	if needle != null:
		update_speed()

func update_speed():
	speed_label.set_text("%.1f%s" % [speed, unit])
	var percent = 100 * speed / max_speed
	needle.set_rot((max_rad-zero_rad)*percent/100 + zero_rad)
