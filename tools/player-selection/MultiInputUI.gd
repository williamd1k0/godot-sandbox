extends Node

signal pressed(action, player)

export(int) var player_count = 1
export(StringArray) var action_names
export(String) var action_template = 'ui_{action}_{player_n}'
var actions = []

func _ready():
	init_actions()
	set_process_input(true)

func init_actions():
	for action in action_names:
		for player in range(player_count):
			actions.append([
				action_template.format({
					'action': action,
					'player_n': player+1
				}), action, player+1
			])

func _input(event):
	if actions.size() == 0:
		return
	for action in actions:
		if event.is_action_pressed(action[0]):
			emit_signal("pressed", action[1], action[2])
			return
