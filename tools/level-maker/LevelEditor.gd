extends Node2D

const ITEM = preload("Item.tscn")
const BTN = preload("ItemButton.tscn")
onready var level = get_node("Level")
var tileset
var items

func _ready():
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_KEEP,
		Vector2(256, 256)
	)
	
	tileset = level.get_node("TileMap").get_tileset()
	items = tileset.get_tiles_ids()
	change_item(items[0])
	generate_buttons()
	get_node("UI/Panel/Items").get_child(0).grab_focus()

func change_item(id):
	var item = ITEM.instance()
	item.create(tileset.tile_get_texture(id), tileset.tile_get_region(id), id)
	get_node("UI/Cursor").set_item(item)

func generate_buttons():
	for c in get_node("UI/Panel/Items").get_children():
		get_node("UI/Panel/Items").remove_child(c)
	for item in items:
		var btn = BTN.instance()
		var tex = AtlasTexture.new()
		tex.set_atlas(tileset.tile_get_texture(item))
		tex.set_region(tileset.tile_get_region(item))
		btn.set_normal_texture(tex)
		get_node("UI/Panel/Items").add_child(btn)
		btn.connect("pressed", self, 'change_item', [item])


func _on_Cursor_add( item, globalpos ):
	level.add(item.id, globalpos)

func _on_Cursor_remove( globalpos ):
	level.remove(globalpos)
