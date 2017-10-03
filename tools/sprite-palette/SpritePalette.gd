tool # tool mode gave me a little headache today.
extends Sprite

export(int, 0, 12) var palette = 0 setget set_palette
export(int) var color_step = 1
export(bool) var force_update = false setget set_force_update
var palette_limit = 0
var palettes
var ready = false
var _palette = 0

func _ready():
	init_palettes()
	init_material()
	ready = true
	set_palette(_palette)
	set_palette_texture(palette)


func init_palettes():
	if palettes == null:
		palettes = Array(get_node("Palettes")._get_resources()[0])
		palette_limit = palettes.size()-1

func init_material():
	var pal = get_node("Palettes").get_resource(palettes[0]).get_data()
	get_material().set_shader_param("color_step", color_step)
	get_material().set_shader_param("colors", pal.get_width())

func set_palette_texture(idx):
	init_palettes()
	init_material()
	get_material().set_shader_param(
		"palette",
		get_node("Palettes").get_resource(palettes[idx])
	)

func set_palette(val):
	if ready:
		init_palettes()
		init_material()
		palette = min(val, palette_limit)
		set_palette_texture(palette)
	else:
		_palette = val

func set_force_update(val):
	if val:
		palettes = null
		init_palettes()
		init_material()
		set_palette_texture(palette)
