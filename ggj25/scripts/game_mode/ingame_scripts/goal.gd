extends Area2D


@onready var sprite: Sprite2D = $Sprite2D
signal bubble_collected

@export var team_id: int = 0

func _ready() -> void:
	sprite.material.set_shader_parameter("line_color", Constants.TEAM_COLOURS[team_id]) 

func _on_body_entered(body: Node2D) -> void:
	if body is Bubble:
		print('bubble collected')
		var bubble = body as Bubble
		bubble.pop()
		bubble_collected.emit(bubble)
