class_name Bubble extends CharacterBody2D


const FRICTION = 0.985


func blow(from: Transform2D, force: float) -> void:
	var direction = (global_transform.origin - from.origin).normalized()
	velocity += direction * force


func _physics_process(_delta: float) -> void:
	
	velocity *= FRICTION
	
	move_and_slide()
