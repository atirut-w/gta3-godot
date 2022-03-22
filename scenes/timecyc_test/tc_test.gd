extends Spatial


onready var _time_label := $CanvasLayer/VBoxContainer/HBoxContainer4/LineEdit as LineEdit


func _ready() -> void:
	GameManager.start_game()


func _process(delta: float) -> void:
	_time_label.text = "%02d:%02d" % [GameManager.time / 60 / 60, (GameManager.time / 60) as int % 60]


func _on_SpinBox_value_changed(value:float):
	GameManager.weather = value as int


func _on_Button_pressed():
	GameManager.time -= 2 * 60 * 60


func _on_Button2_pressed():
	GameManager.time -= 1 * 60 * 60


func _on_Button3_pressed():
	GameManager.time -= 30 * 60


func _on_Button6_pressed():
	GameManager.time += 30 * 60


func _on_Button5_pressed():
	GameManager.time += 1 * 60 * 60


func _on_Button4_pressed():
	GameManager.time += 2 * 60 * 60


func _on_midnight_pressed():
	GameManager.time = 0


func _on_morning_pressed():
	GameManager.time = 6 * 60 * 60


func _on_midday_pressed():
	GameManager.time = 12 * 60 * 60


func _on_evening_pressed():
	GameManager.time = 18 * 60 * 60
