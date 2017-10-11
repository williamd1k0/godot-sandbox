extends Node2D

signal select_all

export(int) var players = 0
export(ColorArray) var player_colors = []

const CURSOR = preload("Cursor.tscn")
const ACTIONS = {
	'left': 'back',
	'right': 'next',
	'select': 'select',
	'cancel': 'deselect'
}

onready var selectables = get_node("Selectables")
onready var cursors = get_node("Cursors")
var players_selections = {}
var selected_all = false

func _ready():
	for p in range(players):
		players_selections[p+1] = {
			'selection': p,
			'selected': false,
		}
		var cursor = CURSOR.instance()
		cursors.add_child(cursor)
		cursor.set_modulate(player_colors[p])
		cursor.get_node("Player").set_text(str(p+1))
		focus(p+1, p)

func can_move(p):
	return not players_selections[p]['selected']

func focus(p, s):
	cursors.get_child(p-1).set_global_pos(selectables.get_child(s).get_focus_pos())
	selectables.get_child(s).grab_focus(p, player_colors[p-1])

func blur(s):
	selectables.get_child(s).blur()

func next(p):
	if not can_move(p):
		return
	for s in range(players_selections[p]['selection'], selectables.get_child_count()):
		if selectables.get_child(s).can_focus():
			blur(players_selections[p]['selection'])
			players_selections[p]['selection'] = s
			focus(p, s)
			break

func back(p):
	if not can_move(p):
		return
	for s in range(players_selections[p]['selection'], -1, -1):
		if selectables.get_child(s).can_focus():
			blur(players_selections[p]['selection'])
			players_selections[p]['selection'] = s
			focus(p, s)
			break

func set_selected(p, selected):
	cursors.get_child(p-1).set_hidden(selected)
	players_selections[p]['selected'] = selected
	selectables.get_child(players_selections[p]['selection']).set_selected(selected)

func select(p):
	set_selected(p, true)
	for i in players_selections.values():
		if not i['selected']:
			return
	selected_all = true
	emit_signal('select_all')

func deselect(p):
	if selected_all:
		return
	set_selected(p, false)

func _on_MultiInputUI_pressed( action, player ):
	if action in ACTIONS:
		call(ACTIONS[action], player)
