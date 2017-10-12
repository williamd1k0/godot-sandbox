extends Node2D

signal add(item, globalpos)
signal remove(globalpos)

const item = preload("Item.tscn")
var selected_item
var pressed

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	set_process_unhandled_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		set_global_pos(get_global_mouse_pos())
		if pressed == BUTTON_LEFT:
			emit_signal("add", selected_item, get_global_pos())
		elif pressed == BUTTON_RIGHT:
			emit_signal("remove", get_global_pos())

func _unhandled_input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pressed = BUTTON_LEFT
			emit_signal("add", selected_item, get_global_pos())
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			pressed = BUTTON_RIGHT
			emit_signal("remove", get_global_pos())
		pressed = event.button_index if event.pressed else 0

func set_item(item):
	for child in get_node("Item").get_children():
		get_node("Item").remove_child(child)
	get_node("Item").add_child(item)
	selected_item = item
