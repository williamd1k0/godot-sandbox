extends Node

signal miss
signal done
signal step(step)

export(StringArray) var actions
export(int) var threshold = 0 # n == 0: none; n > 0: n seconds
const SKIP_EVENTS = [
	InputEvent.MOUSE_BUTTON,
	InputEvent.MOUSE_MOTION,
	InputEvent.SCREEN_TOUCH,
	InputEvent.SCREEN_DRAG,
	InputEvent.JOYSTICK_MOTION
]
onready var timer = get_node("Timer")
var started = false
var command_index = 0

func _ready():
	if threshold > 0:
		timer.set_wait_time(threshold)
		timer.connect("timeout", self, 'command_miss')
	set_process_input(true)

func _input(event):
	if not started and event.is_action_pressed(actions[0]):
		started = true
		command_step()
	elif started:
		if event.is_action_pressed(actions[command_index]):
			if command_index >= actions.size()-1:
				command_done()
			else:
				command_step()
		elif not event.type in SKIP_EVENTS and not event.is_action_released(actions[command_index-1]):
			command_miss()

func command_done():
	if threshold > 0:
		timer.stop()
	#print('done')
	reset_commands()
	emit_signal("done")

func command_step():
	#print('step')
	emit_signal("step", command_index)
	command_index += 1
	if threshold > 0:
		timer.start()

func command_miss():
	if threshold > 0:
		timer.stop()
	#print('miss')
	emit_signal("miss")
	reset_commands()

func reset_commands():
	command_index = 0
	started = false
