class_name Bubble extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const FRICTION = 0.985
const BOUNCE_SCALE = 0.8


func _ready() -> void:
	animated_sprite_2d.play("default")
	animated_sprite_2d.modulate = Color8(135, 224, 237)


func blow(from: Transform2D, force: float) -> void:
	var direction = (global_transform.origin - from.origin).normalized()
	velocity += direction * force


func _physics_process(delta: float) -> void:
	
	velocity *= FRICTION
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())


func pop():
	animated_sprite_2d.play("pop")
	set_collision_layer_value(2, false)
	velocity = Vector2.ZERO
	await get_tree().create_timer(5.0).timeout
	queue_free()

func collect():
	# sound / animation then delete
	queue_free()
