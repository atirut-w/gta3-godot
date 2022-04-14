extends Control


func _ready() -> void:
	var file := File.new()
	var err := file.open(GameManager.game_path + "/models/menu.txd", File.READ)
	if err != OK:
		return
	
	var rwbinstream := RenderWareBinaryStream.new(KaitaiStream.new(file))
	pass
