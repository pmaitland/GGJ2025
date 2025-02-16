extends Node

var scene_history = []

func go_to_scene(scene_path: String) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	scene_history.append(current_scene)
	get_tree().change_scene_to_file(scene_path)

func go_back() -> void:
	if scene_history.size() > 0:
		var last_scene = scene_history.pop_back()
		get_tree().change_scene_to_file(last_scene)
