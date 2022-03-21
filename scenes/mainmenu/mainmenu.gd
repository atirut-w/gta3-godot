extends Node


func _on_Button_pressed():
	var filediag := FileDialog.new()
	filediag.access = FileDialog.ACCESS_RESOURCES
	filediag.mode = FileDialog.MODE_OPEN_FILE
	filediag.window_title = "Open a scene"
	add_child(filediag)

	filediag.popup_centered_minsize(Vector2(600, 500))
	var path = yield(filediag, "file_selected")
	get_tree().change_scene(path)
