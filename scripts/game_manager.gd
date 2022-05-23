extends Node


signal initialized()

var game_path: String


func _ready() -> void:
	game_path = (
		yield(ask_game_dir(), "completed") if OS.has_feature("debug")
		else OS.get_executable_path().get_base_dir()
	)
	
	emit_signal("initialized")
	var err := get_tree().change_scene("res://scenes/mainmenu/mainmenu.tscn")
	assert(err == OK)


func ask_game_dir() -> String:
	var dialog := FileDialog.new()
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.mode = FileDialog.MODE_OPEN_DIR
	dialog.window_title = "Select game directory"
	add_child(dialog)

	dialog.popup_centered_minsize(Vector2(600, 500))
	var path := yield(dialog, "dir_selected") as String
	dialog.queue_free()

	return path
