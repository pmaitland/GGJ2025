extends Control

@onready var game_1: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Game1
@onready var game_2: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Game2
@onready var game_3: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Game3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bubbal_game.tscn")


func _on_game_2_pressed() -> void:
	pass # Replace with function body.


func _on_game_3_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainScreen.tscn")
