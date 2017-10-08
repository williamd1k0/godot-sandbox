extends Polygon2D

signal polygon_changed(polygon)

const debug = true
export(int) var offset = 64

func _ready():
	set_polygon(get_polygon())

func _draw():
	for line in get_lines():
		draw_line(line[0], line[1], Color(0, 0, 1))
	if not debug:
		return
	var triangles = get_triangles()
	for t in range(triangles.size()):
		draw_colored_polygon(
			triangles[t],
			Color(t*0.1, t*0.1, t*0.1, 0.4)
		)

func fix_polygon_grid(vec2array):
	var points = Vector2Array()
	for point in vec2array:
		points.append(fix_point(point))
	return points

func fix_point(point):
	var xy = [int(point.x), int(point.y)]
	for co in range(2):
		var inc = 1
		while int(xy[co]) % offset != 0:
			if int(xy[co]+inc) % offset == 0:
				xy[co] += inc
				break
			elif int(xy[co]-inc) % offset == 0:
				xy[co] -= inc
				break
			inc += 1
	return Vector2(int(xy[0]), int(xy[1]))

func set_polygon(vec2array):
	var points = fix_polygon_grid(vec2array)
	.set_polygon(points)
	update()
	emit_signal('polygon_changed', points)

func vec2to3(vec2):
	return Vector3(vec2.x, vec2.y, 1)

func is_colinear(a, b, c):
	return Matrix3(vec2to3(a), vec2to3(b), vec2to3(c)).determinant() == 0

func is_boundary(line, point):
	if is_colinear(line[0], line[1], point):
		var r = (point - line[0]) / (line[1] - point)
		return r.x >= 0 or r.y >= 0
	return false

func is_inside(point):
	for t in get_triangles():
		if Geometry.point_is_inside_triangle(point, t[0], t[1], t[2]):
			return true
		for line in get_lines(t):
			if is_boundary(line, point):
				return true
	return false

func get_triangles(points=null):
	if points == null:
		points = get_polygon()
	points = Array(points)
	var triangles = []
	while points.size() > 2:
		if not is_colinear(points[0], points[-1], points[1]):
			triangles.append([points[0], points[-1], points[1]])
		points.remove(0)
	return triangles

func get_lines(poly=null):
	var lines = []
	if poly == null:
		poly = get_polygon()
	poly = Array(poly)
	for p in range(poly.size()):
		lines.append([poly[p], poly[p-1]])
	return lines

