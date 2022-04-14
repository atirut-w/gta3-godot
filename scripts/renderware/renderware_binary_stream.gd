class_name RenderWareBinaryStream
extends KaitaiStruct


var code: int
var size: int
var library_id_stamp: int

var _parent: KaitaiStruct
var _root: RenderWareBinaryStream


func _init(io: KaitaiStream, parent: KaitaiStruct = null, root: RenderWareBinaryStream = null).(io) -> void:
	_parent = parent
	_root = root if root != null else self
	_read()


func _read() -> void:
	code = _io.read_u4le()
	size = _io.read_u4le()
	library_id_stamp = _io.read_u4le()
