extends Node2D

var temp


func _ready():
	OS.set_window_size(get_node("Panel").get_size())

func get_area(i, b):
	return i + (b/2.0) - 1

func _on_Grid_polygon_changed( i, b ):
	if temp == null:
		temp = get_node("Panel/Results").get_text()
	var area = get_area(i, b)*pow(get_node("Grid").offset, 2)
	get_node("Panel/Results").set_text(temp.format({
		'i': i, 'b': b, 'u': get_area(i, b), 'a': area
	}))
