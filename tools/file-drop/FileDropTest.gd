extends Node2D


func _ready():
	OS.set_window_size(get_node("Panel").get_size())

func list_files(files):
	get_node("Panel/Files").clear()
	for file in files:
		get_node("Panel/Files").add_item(file.get_file())


func _on_FileDrop_files_dropped( files ):
	get_node("AnimationPlayer").play("files")
	list_files(files)