extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_material(get_material().duplicate())

func set_focus(b):
	get_material().set_shader_param("focus", b)

func _on_mouse_enter():
	set_focus(true)

func _on_focus_enter():
	set_focus(true)

func _on_focus_exit():
	set_focus(false)

func _on_mouse_exit():
	set_focus(false)
