extends Control

@onready var game_1: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Game1
@onready var game_2: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Game2
@onready var screenshot: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/Screenshot
@onready var music: AudioStreamPlayer = $Music

@export var GAME_1_SCREENSHOT: Texture2D
@export var GAME_2_SCREENSHOT: Texture2D

func _ready() -> void:
	music.play()
	game_1.grab_focus()


func _on_game_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_modes/bubbal_game.tscn")


func _on_game_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_modes/dodge_bubbal.tscn")


func _on_game_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_modes/solo_dodge_bubbal.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/MainScreen.tscn")


func _on_game_1_mouse_entered() -> void:
	screenshot.texture = GAME_1_SCREENSHOT


func _on_game_2_mouse_entered() -> void:
	screenshot.texture = GAME_2_SCREENSHOT
