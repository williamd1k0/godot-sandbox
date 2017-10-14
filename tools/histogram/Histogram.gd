tool
extends Node2D

var histogram = [
	[],
	[],
	[]
]
var line_colors = [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1)]
var max_count = 0
var max_height = 200


func _draw():
	var c = 0
	draw_rect(Rect2(0, max_height, 256, -max_height), Color(0, 0, 0, 1))
	for chan in histogram:
		for i in range(1, chan.size()):
			draw_line(
				Vector2(i, max_height-(chan[i-1]/max_count)*max_height),
				Vector2(i, max_height-(chan[i]/max_count)*max_height),
				line_colors[c], 1.0
			)
		c+=1

func generate_histogram(imgtex):
	max_count = 0
	for c in histogram:
		c.resize(256)
		for i in range(c.size()):
			c[i] = 0
	var data = imgtex.get_data()
	for x in range(data.get_width()):
		for y in range(data.get_height()):
			var color = data.get_pixel(x, y)
			histogram[0][color.r8] += 1
			histogram[1][color.g8] += 1
			histogram[2][color.b8] += 1
			max_count = max(max_count, histogram[0][color.r8])
			max_count = max(max_count, histogram[1][color.g8])
			max_count = max(max_count, histogram[2][color.b8])
	max_count = float(max_count)
	update()
