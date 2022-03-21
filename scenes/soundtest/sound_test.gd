extends Control


var _player: AudioStreamPlayer


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)


func _on_Button_pressed():
	var sfx_id := int($HBoxContainer/SpinBox.get_line_edit().text)
	var stream := AudioManager.load_sfx(sfx_id)

	_player.stream = stream
	_player.play()
