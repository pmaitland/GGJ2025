extends Control

@onready var game_mode: Button = $VBoxContainer/GameMode
@onready var controls: Button = $VBoxContainer/Controls
@onready var settings: Button = $VBoxContainer/Settings



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameModeSelection.tscn")
