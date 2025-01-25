extends Control

@onready var game_mode: Button = $VBoxContainer/GameMode
@onready var controls: Button = $VBoxContainer/Controls
@onready var settings: Button = $VBoxContainer/Settings

func _on_game_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameModeSelection.tscn")


func _on_controls_pressed() -> void:
	SceneManager.go_to_scene("res://scenes/ControlsScreen.tscn")


func _on_settings_pressed() -> void:
	SceneManager.go_to_scene("res://scenes/SettingsScreen.tscn")
