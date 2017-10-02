extends Control

onready var player = get_node("MusicPlayer")
onready var play = get_node("Buttons/PlayPause")
onready var previous = get_node("Buttons/Previous")
onready var next = get_node("Buttons/Next")
onready var slide = get_node("Seek")
onready var time = get_node("Time")


func _ready():
	change_music(player.get_music_name())
	player.connect("music_changed", self, 'change_music')
	play.connect("pressed", self, 'on_play_pressed')
	previous.connect("pressed", player, 'previous')
	next.connect("pressed", player, 'next')
	player.connect("finished", player, 'next')
	set_process(true)

func _process(delta):
	if player.is_playing() and not player.is_paused():
		update_music_time()

func update_play_button():
	if player.is_playing() and not player.is_paused():
		play.set_text("Pause")
	else:
		play.set_text("Play")

func change_music(name):
	slide.set_max(player.get_length())
	get_node("Title").set_text(name)
	update_play_button()
	update_music_time()

func update_music_time():
	slide.set_val(player.get_pos())
	var times = [
		player.get_pos()/60, fmod(player.get_pos(), 60.0),
		player.get_length()/60, fmod(player.get_length(), 60.0)
	]
	time.set_text("%02d:%02d/%02d:%02d" % times)

func on_play_pressed():
	if player.is_playing() and not player.is_paused():
		player.set_paused(true)
	elif player.is_paused():
		player.set_paused(false)
	else:
		player.play(player.get_pos())
	update_play_button()
