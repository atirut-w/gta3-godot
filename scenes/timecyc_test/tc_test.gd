extends Spatial


func _ready() -> void:
	GameManager.start_game()


func _on_SpinBox_value_changed(value:float):
	GameManager.weather = value as int
