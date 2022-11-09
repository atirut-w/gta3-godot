class_name RWChunk
extends RefCounted
## Base class for RenderWare chunks


var type: int
var size: int
var library_id: int

var _start: int


func _init(file: FileAccess):
	type = file.get_32()
	size = file.get_32()
	library_id = file.get_32()
	assert(library_id == 0x0c02ffff) # TODO: Other versions
	_start = file.get_position()


func skip(file: FileAccess) -> void:
	file.seek(_start + size)