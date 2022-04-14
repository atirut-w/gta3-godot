class_name KaitaiStream
extends Reference


var _io: File


func _init(io: File) -> void:
	_io = io


func read_u4le() -> int:
	return _io.get_32()


func read_bytes(n: int) -> PoolByteArray:
	var r := _io.get_buffer(n)
	if not (n <= r.size()):
		push_error("requested %d bytes, but only %d bytes available" % [n, r.size()])
	
	return r
