extends Node


signal initialized()

var game_path := ""
var state: int

enum GameState {
	STARTUP,
	MAIN_MENU,
	IN_GAME,
}


func _ready() -> void:
	state = GameState.STARTUP
	yield(choose_game_path(), "completed")
	emit_signal("initialized")
	print("Load main menu")
	var err := get_tree().change_scene("res://scenes/mainmenu/mainmenu.tscn")
	assert(err == OK)


# Promp the user for the game path
func choose_game_path() -> void:
	print("Asking user for game path")
	var filediag := FileDialog.new()
	filediag.access = FileDialog.ACCESS_FILESYSTEM
	filediag.mode = FileDialog.MODE_OPEN_DIR
	filediag.window_title = "Choose the game directory"

	add_child(filediag)
	filediag.popup_centered_minsize(Vector2(600, 500))
	game_path = yield(filediag, "dir_selected")
	filediag.queue_free()

	print("Game path: " + game_path)
