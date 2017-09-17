extends Node2D

export(Vector2) var size = Vector2(8, 8)
export(int) var offset = 64

onready var polygon = get_node("Polygon")
var raw_poly
var outer_points = 0
var inner_points = 0

func _ready():
	polygon.offset = offset
	polygon.set_polygon(polygon.get_polygon())
	polygon.set_color(Color(1, 0, 1, 0.5))
	polygon.set_vertex_colors([Color(0, 1, 1, 0.5)])

func draw_grid():
	for y in range(size.y):
		for x in range(size.x):
			draw_circle(Vector2(x, y)*offset, 2.0, Color(1, 1, 1))

func collect_points():
	for y in range(size.y):
		for x in range(size.x):
			if polygon.has_point(Vector2(x, y)*offset):
				print(Vector2(x, y))

func _draw():
	draw_grid()


func _on_Polygon_polygon_changed( poly ):
	if polygon:
		collect_points()
