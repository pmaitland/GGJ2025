class_name Bubble extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pop_sound: AudioStreamPlayer2D = $PopSound

var paused = false

const FRICTION = 0.985
const BOUNCE_SCALE = 0.8

func set_paused(p: bool):
	paused = p

func _ready() -> void:
	animated_sprite_2d.modulate = Color8(227, 161, 218)
	animated_sprite_2d.play("default")


func blow(from: Transform2D, force: float) -> void:
	var direction = (global_transform.origin - from.origin).normalized()
	velocity += direction * force


func _physics_process(delta: float) -> void:
	if (paused): return
	
	velocity *= FRICTION
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())


func pop():
	animated_sprite_2d.play("pop")
	pop_sound.pitch_scale = 1 + randf_range(0, 0.25)
	pop_sound.play()
	set_collision_layer_value(2, false)
	velocity = Vector2.ZERO
	await get_tree().create_timer(5.0).timeout
	queue_free()

func collect():
	# sound / animation then delete
	queue_free()
