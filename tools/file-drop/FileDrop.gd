extends Area2D

signal files_dropped(files)

var local_dragging = false
var files

func _ready():
	connect("mouse_enter", self, 'set_drag_input', [true])
	connect("mouse_exit", self, 'set_drag_input', [false])
	get_tree().connect("files_dropped", self, "_on_files_dropped")

func process_files(files_):
	files = files_
	emit_signal("files_dropped", files)

func set_drag_input(enabled):
	local_dragging = enabled

func _on_files_dropped(files, screen):
	if local_dragging:
		process_files(files)
