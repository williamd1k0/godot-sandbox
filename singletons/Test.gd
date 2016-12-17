extends Node

func _ready():
	print(Dir2D.up)
	print(Dir2D.dirs["up"])
	
	print(FilePath.file_exists("res://Test.gd"))
	print(FilePath.file_exists("res://Unknown.gd"))
