extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bubble:
		print(name, ' hit bubble')
		(body as Bubble).pop()
