extends CanvasLayer

func _ready() -> void:
	hide()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")
	get_tree().paused = false
	hide()

func _on_continue_pressed() -> void:
	var currScene = get_tree().current_scene.scene_file_path
	var nextLvl = currScene.to_int() + 1
	var nextLvl_path = "res://assets/levels/level" + str(nextLvl) + ".tscn"
	get_tree().change_scene_to_file(nextLvl_path)
	get_tree().paused = false
	hide()

func _on_exit_game_pressed() -> void:
	get_tree().quit()
