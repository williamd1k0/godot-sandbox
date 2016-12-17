extends Node

var __FILE = File.new()
var __MODES = {
	"r": __FILE.READ,
	"w": __FILE.WRITE,
	"rw": __FILE.READ_WRITE,
	"wr": __FILE.WRITE_READ
}


func file_exists(path):
	return __FILE.file_exists(path)

func get_md5(path):
	return __FILE.get_md5(path)

func get_sha256(path):
	return __FILE.get_sha256(path)

func open(path, mode):
	var file = File.new()
	file.open(path, __MODES[mode])
	return file
	
func open_with_key(path, mode, key):
	var file = File.new()
	file.open_encrypted(path, __MODES[mode], key)
	return file

func open_with_pass(path, mode, pass_):
	var file = File.new()
	file.open_encrypted_with_pass(path, __MODES[mode], pass_)
	return file
	