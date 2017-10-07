extends PathFollow2D

export(bool) var enabled = true
export(float) var orbit_time = 3
export(float) var rotation_time = 1
export(bool) var rotation = true
var tween = Tween.new()
var spin = Tween.new()

func _ready():
	if enabled:
		add_child(tween)
		add_child(spin)
		tween.set_repeat(true)
		spin.set_repeat(true)
		start_orbit()
		if rotation:
			start_spin()

func start_orbit():
	tween.interpolate_method(
		self,
		'set_unit_offset',
		0.0, 1.0,
		orbit_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween.start()

func start_spin():
	spin.interpolate_method(
		get_node("Sprite"),
		'set_rot',
		0.0, -2*PI,
		rotation_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	spin.start()
