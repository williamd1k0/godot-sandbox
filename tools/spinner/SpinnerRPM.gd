extends Node2D

onready var spinner = get_node("Spinner")
onready var speedometer = get_node("Speedometer")

func _ready():
	OS.set_window_size(get_node("Panel").get_size())

func _process(delta):
	speedometer.speed = spinner.rpm

func _on_Spinner_spin():
	set_process(true)

func _on_Spinner_stop():
	speedometer.speed = 0
	set_process(false)
