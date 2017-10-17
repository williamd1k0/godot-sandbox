extends Control

onready var tree = get_node("Panel/Tree")

func _ready():
	OS.set_window_size(get_node("Panel").get_size())


func set_filename(name):
	get_node("Panel/Name").set_text('JSON FILE: %s' % name)

func add_object(obj, name, parent=null):
	var valitem = tree.create_item(parent)
	valitem.set_text(0, str(name))
	for key in obj:
		if typeof(obj[key]) == TYPE_ARRAY:
			add_array(obj[key], key, valitem)
		elif typeof(obj[key]) == TYPE_DICTIONARY:
			add_object(obj[key], key, valitem)
		else:
			var valitem2 = tree.create_item(valitem)
			valitem2.set_text(0, str(key))
			add_string(obj[key], valitem2)

func add_array(array, name, parent=null):
	var valitem = tree.create_item(parent)
	valitem.set_text(0, str(name))
	for val in range(array.size()):
		if typeof(array[val]) == TYPE_ARRAY:
			add_array(array[val], val, valitem)
		elif typeof(array[val]) == TYPE_DICTIONARY:
			add_object(array[val], val, valitem)
		else:
			add_string(array[val], valitem)

# idk how to use other cell types yet :/
func add_string(val, parent=null):
	var valitem = tree.create_item(parent)
	valitem.set_text(0, str(val))

func _on_DropJson_json_dropped( name, json ):
	set_filename(name)
	tree.clear()
	var root = tree.create_item()
	root.set_text(0, name)
	add_object(json, '[json data]', root)
