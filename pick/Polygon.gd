extends Polygon2D

signal polygon_changed(polygon)

var offset = 64

var poly_corners  =  0 # how many corners the polygon has (no repeats)
var poly_x = [] # horizontal coordinates of corners
var poly_y = [] # vertical coordinates of corners
var constant = [] # storage for precalculated constants (same size as poly_x)
var multiple = [] # storage for precalculated multipliers (same size as poly_x)
var vertices_pos = [] # storage for global coordinates of polygon's vertices

func _ready():
	fix_polygon_grid(get_polygon())
	inic()

func fix_polygon_grid(vec2array):
	var points = Vector2Array()
	for point in vec2array:
		var p = Vector2(int(point.x), int(point.y))
		while int(p.x) % offset != 0:
			p.x -= 1
		while int(p.y) % offset != 0:
			p.y -= 1
		points.append(p)
	.set_polygon(points)
	inic()
	emit_signal('polygon_changed', points)

func set_polygon(vec2array):
	fix_polygon_grid(vec2array)


func inic():
    var poly_pos = get_pos() # global position of polygon
    var vertices = get_polygon() # local coordiantes of vertices

    poly_corners = vertices.size()
    poly_x.resize(poly_corners)
    poly_y.resize(poly_corners)
    constant.resize(poly_corners)
    multiple.resize(poly_corners)
    vertices_pos.resize(poly_corners)

    for i in range(poly_corners): 
        vertices_pos[i] = poly_pos + vertices[i]
        poly_x[i] = vertices_pos[i].x
        poly_y[i] = vertices_pos[i].y

    precalc_values_has_point(poly_x, poly_y)

func precalc_values_has_point(poly_x, poly_y): # precalculation of constant and multiple
    var j = poly_corners - 1
    for i in range(poly_corners): 
        if poly_y[j] == poly_x[i]:
            constant[i] = poly_y[i]
            multiple[i] = 0.0
        else:
            constant[i] = poly_x[i] - poly_y[i] * poly_x[j] / (poly_y[j] - poly_y[i]) + poly_y[i] * poly_x[i] / (poly_y[j] - poly_y[i])
            multiple[i] = (poly_x[j] - poly_x[i]) / (poly_y[j] - poly_y[i])
        j = i

func has_point(point):
    var x = point.x
    var y = point.y
    var j = poly_corners - 1
    var odd_nodes = 0
    for i in range(poly_corners): 
        if (poly_y[i] < y and poly_y[j] >= y) or (poly_y[j] < y and poly_y[i] >= y):
            if y * multiple[i] + constant[i] < x:
                odd_nodes += 1
        j = i

    if odd_nodes % 2 == 0:
        return false
    else:
        return true
