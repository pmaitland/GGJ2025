class_name Bubble extends CharacterBody2D


const FRICTION = 0.985
const BOUNCE_SCALE = 0.8

func blow(from: Transform2D, force: float) -> void:
	var direction = (global_transform.origin - from.origin).normalized()
	velocity += direction * force


func _physics_process(delta: float) -> void:
	
	velocity *= FRICTION
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())


func pop():
	# play pop animation then delete
	queue_free()

func collect():
	# sound / animation then delete
	queue_free()
