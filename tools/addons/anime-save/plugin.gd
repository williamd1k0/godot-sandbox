tool
extends EditorPlugin

var button
var animation_node
var selection
var dialog


func _init():
	button = ToolButton.new()

func _ready():
	selection = get_selection()
	selection.connect("selection_changed", self, "_selection_changed")
	#button.set_button_icon(preload("icon.png"))
	button.set_text("Export")
	button.connect("pressed", self, "_export_animations")
	button.hide()


func _enter_tree():
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, button)

func _exit_tree():
	button.queue_free()

func _export_animations():
	if dialog == null:
		dialog = preload("ExportDialog.tscn").instance()
		add_child(dialog)
	var animations = []
	print(animation_node.get_animation_list())
	for anime in animation_node.get_animation_list():
		animations.append([anime, animation_node.get_animation(anime)])
	dialog.export_animations_dialog(animations)

func _selection_changed():
	var selects = selection.get_selected_nodes()
	if selects.size() > 0:
		if selects[0] extends AnimationPlayer:
			animation_node = selects[0]
			button.show()
		else:
			button.hide()
