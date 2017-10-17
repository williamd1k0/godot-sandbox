extends Node

signal json_dropped(name, json)

func _ready():
	get_tree().connect("files_dropped", self, '_on_files_dropped')

func load_json(path):
	var f = File.new()
	f.open(path, File.READ)
	var json = {}
	json.parse_json(f.get_as_text())
	return json

func _on_files_dropped(files, screen):
	for file in files:
		if file.ends_with('.json'):
			emit_signal('json_dropped', file.get_file(), load_json(file))
			break
