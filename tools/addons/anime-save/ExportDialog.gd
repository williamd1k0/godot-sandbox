tool
extends FileDialog

var animations = []


func export_animations_dialog(animations_):
	animations = animations_
	call_deferred('popup_centered')

func export_animations():
	for anime in animations:
		ResourceSaver.save(get_current_dir() + '/%s.tres' % anime[0], anime[1], 0)
	get_node("Done").popup_centered()

func _on_FileDialog_confirmed():
	export_animations()
