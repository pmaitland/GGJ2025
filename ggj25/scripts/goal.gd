extends Area2D


@export var team_id: int = 0

signal bubble_collected

func _on_body_entered(body: Node2D) -> void:
	if body is Bubble:
		print('bubble collected')
		(body as Bubble).collect()
		bubble_collected.emit(team_id)
