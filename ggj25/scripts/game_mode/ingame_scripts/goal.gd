extends Area2D


signal bubble_collected

func _on_body_entered(body: Node2D) -> void:
	if body is Bubble:
		print('bubble collected')
		var bubble = body as Bubble
		bubble.pop()
		bubble_collected.emit(bubble)
