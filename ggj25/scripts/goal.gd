extends Area2D


@export var team_id: int = 0
@onready var sprite: Sprite2D = $Sprite2D

signal bubble_collected

const TEAM_COLOURS = [
	Color8(239, 153, 56), # Orange
	Color8(161, 118, 219), # Purple
]

func _ready() -> void:
	sprite.material.set_shader_parameter("outline_color", TEAM_COLOURS[team_id]) 

func _on_body_entered(body: Node2D) -> void:
	if body is Bubble:
		print('bubble collected')
		(body as Bubble).pop()
		bubble_collected.emit(team_id)
