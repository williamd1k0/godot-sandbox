extends Node2D

export(Color) var bg
onready var canvas = get_node("Canvas")
onready var anime = get_node("AnimationPlayer")
var drawing = false

func _ready():
	VisualServer.set_default_clear_color(bg)
	OS.set_window_size(canvas.get_item_rect().size)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("lmb"):
		if not drawing:
			anime.play("draw")
		canvas.paint_request(get_local_mouse_pos())
		drawing = true
	elif drawing:
		drawing = false
		anime.play("idle")
		canvas.paint_done()
	if Input.is_action_pressed("ui_cancel"):
		canvas.clear()
	get_node("Pen").set_global_pos(get_global_mouse_pos())
