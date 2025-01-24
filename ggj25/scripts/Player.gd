extends CharacterBody2D

@onready var blow_hitbox: ShapeCast2D = $BlowHitbox

const SPEED = 200.0
const BLOW_FORCE = 20


func _physics_process(delta: float) -> void:
	var x_direction := Input.get_axis("move_left", "move_right")
	if x_direction:
		velocity.x = x_direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var y_direction := Input.get_axis("move_up", "move_down")
	
	if y_direction:
		velocity.y = y_direction
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
			
	velocity = velocity.normalized()
	velocity *= SPEED
	
	if Input.is_action_pressed("blow"):
		blow()

	move_and_slide()




func blow() -> void:
	if blow_hitbox.is_colliding():
		for i in range(blow_hitbox.get_collision_count()):
			var hit = blow_hitbox.get_collider(i)
			if "name" in hit:
				print('hit ', hit.name)
			if hit and hit.has_method("blow"):
				hit.call("blow", global_transform, BLOW_FORCE)
