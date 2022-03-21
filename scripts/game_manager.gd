extends Node


signal initialized()

var game_path := ""
var state: int

var world_env: WorldEnvironment
var sun: DirectionalLight
var time: float
var time_speed := 60.0 * 60.0
var lighting_update_threshold := 0.1
var weather: int

var _last_lighting_update := 0.0
var _weathers: Array

enum GameState {
	STARTUP,
	MAIN_MENU,
	IN_GAME,
}


func _ready() -> void:
	state = GameState.STARTUP
	yield(choose_game_path(), "completed")
	_load_timecyc()
	emit_signal("initialized")
	print("Load main menu")
	var err := get_tree().change_scene("res://scenes/mainmenu/mainmenu.tscn")
	assert(err == OK)


func _physics_process(delta: float) -> void:
	match state:
		GameState.IN_GAME:
			print("The time is %d:%d:%d" % [
				(time / 60 / 60) as int % 24,
				(time / 60) as int % 60,
				(time) as int % 60,
			])
			time += delta * time_speed
			if time > 86400.0:
				time = 0.0

			_last_lighting_update += delta
			if _last_lighting_update > lighting_update_threshold:
				_last_lighting_update = 0.0
				_update_lighting()


func _update_lighting() -> void:
	print("Update lighting")
	var sun_rotation := Vector3((time / 86400.0) * 360.0 + 90, -90.0, 0.0)
	var latitude := sun_rotation.x + 180
	var longitude := sun_rotation.y + 180
	sun.rotation_degrees = sun_rotation
	world_env.environment.background_sky.sun_latitude = latitude
	world_env.environment.background_sky.sun_longitude = longitude

	var wdata := _weathers[weather] as Weather

	var topcol := wdata.sky_top.interpolate(time / 3600.0)
	var bottomcol := wdata.sky_bottom.interpolate(time / 3600.0)
	world_env.environment.background_sky.sky_top_color = topcol
	world_env.environment.background_sky.sky_horizon_color = topcol.linear_interpolate(bottomcol, 0.5)
	world_env.environment.background_sky.ground_horizon_color = bottomcol.linear_interpolate(topcol, 0.5)
	world_env.environment.background_sky.ground_bottom_color = bottomcol
	world_env.environment.ambient_light_color = wdata.amb.interpolate(time / 3600.0)

func _load_timecyc() -> void:
	print("Load timecyc")
	var file = File.new()
	var err = file.open(game_path + "/data/timecyc.dat", File.READ)
	assert(err == OK)

	for wi in 4:
		var wdata := Weather.new()
		for li in 24:
			var line := file.get_line() as String
			while line.begins_with("//"):
				line = file.get_line() as String
			var parts := line.replacen("\t", " ").rsplit(" ", false)

			wdata.amb.add_point(li, Color(float(parts[0]) / 255, float(parts[1]) / 255, float(parts[2]) / 255))
			wdata.sky_top.add_point(li, Color(float(parts[6]) / 255, float(parts[7]) / 255, float(parts[8]) / 255))
			wdata.sky_bottom.add_point(li, Color(float(parts[9]) / 255, float(parts[10]) / 255, float(parts[11]) / 255))
		# Godot devs, please remove the two default points from gradients.
		# They are a huge pain in the ass to deal with.
		wdata.amb.remove_point(0)
		wdata.amb.remove_point(0)

		wdata.sky_top.remove_point(0)
		wdata.sky_top.remove_point(0)
		wdata.sky_bottom.remove_point(0)
		wdata.sky_bottom.remove_point(0)

		_weathers.append(wdata)
	print("Loaded timecyc")


func start_game() -> void:
	print("Start game")
	world_env = WorldEnvironment.new()
	world_env.environment = load(ProjectSettings["rendering/environment/default_environment"])
	world_env.environment.background_mode = Environment.BG_SKY
	world_env.environment.background_sky = ProceduralSky.new()
	world_env.environment.ambient_light_sky_contribution = 0.0
	add_child(world_env)

	sun = DirectionalLight.new()
	sun.shadow_enabled = true
	add_child(sun)

	time = 7.75 * 60 * 60
	state = GameState.IN_GAME
	_update_lighting()


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


class Weather:
	var amb := Gradient.new()
	var dir := Gradient.new()
	var sky_top := Gradient.new()
	var sky_bottom := Gradient.new()
	var suncore := Gradient.new()
	var suncorona := Gradient.new()
	var sunsz := Curve.new()
	var sprsz := Curve.new()
	var sprbght := Curve.new()
	var shdw := Curve.new()
	var lightshd := Curve.new()
	var treeshd := Curve.new()
	var farclp := Curve.new()
	var fogst := Curve.new()
	var lightonground := Curve.new()
	var lowcloudsrgb := Gradient.new()
	var topcloudrgb := Gradient.new()
	var bottomcloudrgb := Gradient.new()
