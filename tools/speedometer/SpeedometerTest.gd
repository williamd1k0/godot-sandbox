extends Control

export(float) var acceleration = 60
onready var speedometer = get_node("Speedometer")
onready var status = get_node("Status")


func _ready():
	OS.set_window_size(Vector2(350, 380))
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		speedometer.speed += delta * acceleration
		status.set_text("Speeding up")
	elif Input.is_action_pressed("ui_down"):
		speedometer.speed -= delta * acceleration*3 # hardcoded braking
		status.set_text("Braking")
	elif speedometer.speed > 0:
		speedometer.speed -= delta * (acceleration/3) # hardcoded deceleration
		status.set_text("Slowing down")
	else:
		status.set_text("Idle")
