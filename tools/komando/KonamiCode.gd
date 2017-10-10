extends Control

const CODES = ['UP', 'UP', 'DOWN', 'DOWN', 'LEFT', 'RIGHT', 'LEFT', 'RIGHT', 'B', 'A']
onready var codes_container = get_node("Panel/Codes")
onready var feedback = get_node("Panel/Feedback")
var codes = []

func _ready():
	OS.set_window_size(get_node("Panel").get_size())
	feedback.set_text("Start")
	for code in CODES:
		var code_button = Button.new()
		code_button.set_text(code)
		codes.append(code_button)

func _on_Komando_step( step ):
	feedback.set_text("Waiting for the next command...")
	codes_container.add_child(codes[step])


func _on_Komando_miss():
	feedback.set_text("Oops, try again!")
	for child in codes_container.get_children():
		codes_container.remove_child(child)

func _on_Komando_done():
	feedback.set_text("Done!!")
	codes_container.add_child(codes[-1])
