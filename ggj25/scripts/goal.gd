extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bubble:
		print('bubble collected')
		body.queue_free()
