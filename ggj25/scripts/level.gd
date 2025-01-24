extends Node2D

@onready var hud: CanvasLayer = $Hud

func new_game() -> void:
	hud.show_game_start()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
