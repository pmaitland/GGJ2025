extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	var x_direction := Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var y_direction := Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
			
	velocity = velocity.normalized()
	velocity *= SPEED

	move_and_slide()
