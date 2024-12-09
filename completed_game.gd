extends CanvasLayer

func _ready() -> void:
	hide()

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/levels/level1.tscn")
	get_tree().paused = false
	hide()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")
	get_tree().paused = false
	hide()

func _on_exit_pressed() -> void:
	get_tree().quit()
