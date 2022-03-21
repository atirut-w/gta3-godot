extends Node


signal initialized()

var game_path := ""
var state: int

var world_env: WorldEnvironment
var sun: DirectionalLight
var time: float
var lighting_update_threshold := 1.0

var _last_lighting_update := 0.0

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


func start_game() -> void:
	world_env = WorldEnvironment.new()
	world_env.environment.background_mode = Environment.BG_SKY
	world_env.environment.background_sky = ProceduralSky.new()
	add_child(world_env)

	sun = DirectionalLight.new()
	sun.shadow_enabled = true
	add_child(sun)

	time = 0.0
	state = GameState.IN_GAME


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
