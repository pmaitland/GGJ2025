extends CharacterBody2D


const friction = 1


func blow(from: Transform2D, force: float) -> void:
	var direction = (global_transform.origin - from.origin).normalized()
	velocity += direction * force


func _physics_process(delta: float) -> void:
	
	velocity.x = move_toward(velocity.x, 0, friction)
	velocity.y = move_toward(velocity.y, 0, friction)
	
	move_and_slide()
	
