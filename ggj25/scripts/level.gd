extends Node2D

@onready var hud: CanvasLayer = $Hud

func new_game() -> void:
	hud.show_game_start()
