extends Sprite

var id = 0

func create(tex, region=null, id_=0):
	id = id_
	if region != null:
		set_region_rect(region)
	else:
		set_region(false)
	set_texture(tex)
