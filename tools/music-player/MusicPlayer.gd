extends StreamPlayer

signal volume_changed(volume)
signal music_changed(name)

onready var musiclist = get_node("Musics")
var musics = []
var music_name

func _ready():
	musics = Array(musiclist._get_resources()[0])
	if musics.size() > 0:
		change_music(musics[0], has_autoplay())

func next():
	if musics.size() > 1:
		musics.push_back(musics[0])
		musics.pop_front()
		change_music(musics[0])

func previous():
	if musics.size() > 1:
		musics.push_front(musics[-1])
		musics.pop_back()
		change_music(musics[0])

func change_music(name, play=true):
	music_name = name
	stop()
	set_stream(musiclist.get_resource(name))
	if play:
		play()
	emit_signal("music_changed", format_name(name))

func get_music_name():
	return format_name(music_name)

func format_name(path):
	return path.replace('-', ' ').replace('_', ' ').replace('   ', ' - ')
