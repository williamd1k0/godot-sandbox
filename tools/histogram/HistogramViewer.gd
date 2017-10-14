extends Node2D

onready var image = get_node("Image")
onready var histogram = get_node("Histogram")

func _ready():
	OS.set_window_size(get_node("Panel").get_size())
	histogram.call_deferred('generate_histogram', image.get_texture())
	get_tree().connect("files_dropped", self, '_on_files_dropped')

func _on_files_dropped(files, screen):
	var f = files[0]
	for ext in ['png', 'jpg', 'jpeg', 'webp']:
		if f.ends_with(ext):
			var img = load(f)
			image.set_texture(img)
			histogram.call_deferred('generate_histogram', img)
			return
