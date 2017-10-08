extends Node2D

signal polygon_changed(i, b)

export(Vector2) var size = Vector2(8, 8)
export(int) var offset = 64

onready var polygon = get_node("Polygon")
var boundary_points = []
var interior_points = []

func _ready():
	get_node("GridTool").hide()
	polygon.set_polygon(polygon.get_polygon())
	polygon.set_color(Color(1, 0, 1, 0.3))


func collect_points():
	var inside = []
	boundary_points = []
	interior_points = []
	for y in range(size.y):
		for x in range(size.x):
			for line in polygon.get_lines():
				if polygon.is_boundary(line, Vector2(x, y)*offset):
					if not Vector2(x, y) in boundary_points:
						boundary_points.append(Vector2(x, y))
				elif polygon.is_inside(Vector2(x, y)*offset):
					if not Vector2(x, y) in inside:
						inside.append(Vector2(x, y))
	for p in inside:
		if not p in boundary_points:
			interior_points.append(p)
	emit_signal("polygon_changed", interior_points.size(), boundary_points.size())
	update()

func draw_grid():
	for y in range(1, size.y):
		for x in range(1, size.x):
			draw_circle(Vector2(x, y)*offset, 2.0, Color(1, 1, 1))
	for p in boundary_points:
		draw_circle(p*offset, 3, Color(0, 1, 0))
	for p in interior_points:
		draw_circle(p*offset, 3, Color(1, 0, 0))
	var rect_points = [
		Vector2(0, 0), Vector2(size.x, 0)*offset,
		Vector2(size.x, size.y)*offset,
		Vector2(0, size.y)*offset
	]
	for p in range(rect_points.size()):
		draw_line(rect_points[p-1], rect_points[p], Color(1, 1, 1), 3)

func _draw():
	draw_grid()

func _on_Polygon_polygon_changed( poly ):
	if polygon:
		collect_points()
