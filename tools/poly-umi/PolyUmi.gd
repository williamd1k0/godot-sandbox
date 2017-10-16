tool
extends Node2D

export(int) var hsize = 5
export(int) var vsize = 5
export(Vector2) var pixel_size = Vector2(1, 1)
export(Vector2) var randrange = Vector2(0.2, 0.2)
export(bool) var vrandom = true
export(bool) var hrandom = false
export(float) var timer = 0.1
export(bool) var enabled = true
var triangles = []
var delta_acc = 0

func _ready():
	randomize()
	generate_triangles()
	set_process(not get_tree().is_editor_hint()) # disable in-editor updates

func _process(delta):
	if not enabled:
		return
	delta_acc += delta
	if delta_acc >= timer:
		delta_acc = 0
		generate_triangles()
	
func generate_triangles():
	var lines = []
	triangles.resize(0)
	for y in range(abs(vsize)):
		var line = []
		for x in range(abs(hsize)):
			var point = Vector2(x, y)
			if hrandom:
				point.x += rand_range(-randrange.x, randrange.x)
			if vrandom:
				point.y += rand_range(-randrange.y, randrange.y)
			point *= pixel_size
			line.append(point)
		lines.append(line)
		if y > 0:
			var poly = Vector2Array(lines[y-1])
			var inverted = Vector2Array(lines[y])
			inverted.invert()
			poly.append_array(inverted)
			triangles += get_triangles(poly)
	update()

func get_triangles(poly):
	poly = Array(poly)
	var tri = []
	var index = 0
	while poly.size() > 2:
		tri.append([poly[-1], poly[0], poly[1]])
		poly.remove(0)
		poly.invert()
	return tri

func _draw():
	for tri in triangles:
		draw_colored_polygon(tri, Color(randf()/3, 1-randf()/3, 1.0))
