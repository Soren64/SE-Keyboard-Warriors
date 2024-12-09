extends CanvasLayer

var save_path = "user://savedata.save"

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/levels/level1.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_load_game_pressed() -> void:
	if FileAccess.file_exists(save_path):
		var save = FileAccess.open(save_path, FileAccess.READ)
		var data = save.get_as_text()
		get_tree().change_scene_to_file(data)
