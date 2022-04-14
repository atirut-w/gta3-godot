class_name KaitaiStream
extends Reference


var _io: File


func _init(io: File) -> void:
	_io = io


func read_u4le() -> int:
	return _io.get_32()
