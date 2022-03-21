extends Node


signal initialized()

var game_path := ""
var state: int

var world_env: WorldEnvironment
var sun: DirectionalLight
var time: float
var time_speed := 60
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


func _physics_process(delta: float) -> void:
	match state:
		GameState.IN_GAME:
			# print("The time is %d:%d:%d" % [
			# 	(time / 60 / 60) as int % 24,
			# 	(time / 60) as int % 60,
			# 	(time) as int % 60,
			# ])
			time += delta * time_speed
			if time > 86400.0:
				time = 0.0

			_last_lighting_update += delta
			if _last_lighting_update > lighting_update_threshold:
				_last_lighting_update = 0.0
				_update_lighting()


func _update_lighting() -> void:
	pass


func start_game() -> void:
	print("Start game")
	world_env = WorldEnvironment.new()
	world_env.environment = Environment.new()
	world_env.environment.background_mode = Environment.BG_SKY
	world_env.environment.background_sky = ProceduralSky.new()
	add_child(world_env)

	sun = DirectionalLight.new()
	sun.shadow_enabled = true
	add_child(sun)

	time = 7.75 * 60 * 60
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
