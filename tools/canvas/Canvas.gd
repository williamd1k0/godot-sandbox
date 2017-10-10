extends Sprite

export(ImageTexture) var brush
onready var brush_data = brush.get_data()
onready var brush_rect = brush_data.get_used_rect()
var copy_data
var paint_points = Vector2Array()

func _ready():
	copy_data = get_texture().get_data()

func _draw():
	for point in paint_points:
		draw_texture(brush, point-(brush_rect.size/2))

func paint_request(localpos):
	localpos = Vector2(int(localpos.x), int(localpos.y))
	if not localpos in paint_points:
		if is_drawable(localpos):
			paint_points.append(localpos)
			update()

func is_drawable(point):
	# totally not cheap limits checking method
	var corners = [
		Vector2(point.x-brush_rect.size.x/2, point.y-brush_rect.size.y/2),
		Vector2(point.x+brush_rect.size.x/2, point.y-brush_rect.size.y/2),
		Vector2(point.x+brush_rect.size.x/2, point.y+brush_rect.size.y/2),
		Vector2(point.x-brush_rect.size.x/2, point.y+brush_rect.size.y/2)
	]
	for c in corners:
		if copy_data.get_pixel(c.x, c.y).a < 1:
			return false
	return true

func paint_done():
	if paint_points.size() == 0:
		return
	paint_points(paint_points)
	paint_points.resize(0)
	update()

func paint_points(points):
	var data = get_texture().get_data()
	for point in points:
		data.blend_rect(brush_data, brush_rect, point-(brush_rect.size/2))
	get_texture().set_data(data)

func paint(localpos):
	paint_points([localpos])

func clear():
	get_texture().set_data(copy_data)

