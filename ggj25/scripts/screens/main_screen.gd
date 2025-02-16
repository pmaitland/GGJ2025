extends Control

@onready var game_mode: Button = $VBoxContainer/GameMode
@onready var controls: Button = $VBoxContainer/Controls
@onready var settings: Button = $VBoxContainer/Settings


func _ready():
	game_mode.grab_focus()


func _on_game_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/GameModeSelection.tscn")


func _on_controls_pressed() -> void:
	SceneManager.go_to_scene("res://scenes/screens/ControlsScreen.tscn")


func _on_settings_pressed() -> void:
	SceneManager.go_to_scene("res://scenes/screens/SettingsScreen.tscn")
