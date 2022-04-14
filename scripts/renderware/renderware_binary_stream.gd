class_name RenderWareBinaryStream
extends KaitaiStruct


var _parent: KaitaiStruct
var _root: RenderWareBinaryStream


func _init(io: KaitaiStream, parent: KaitaiStruct = null, root: RenderWareBinaryStream = null).(io):
	_parent = parent
	_root = root if root != null else self
