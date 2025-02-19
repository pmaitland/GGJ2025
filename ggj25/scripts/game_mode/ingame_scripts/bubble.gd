class_name Bubble extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pop_sound: AudioStreamPlayer2D = $PopSound

const NO_PLAYER_ID = -1

@export var player_id: int = NO_PLAYER_ID

var paused = false

const FRICTION = 0.985
const BOUNCE_SCALE = 0.8
const DEFAULT_COLOR = Color8(227, 161, 218)

func set_paused(p: bool):
	paused = p


func set_player_id(player_id: int) -> void:
	self.player_id = player_id
	


func _ready() -> void:
	animated_sprite_2d.modulate = Constants.DUCK_COLOURS[player_id] if player_id != NO_PLAYER_ID else DEFAULT_COLOR
	animated_sprite_2d.play("default")


func can_be_blown_by(player_id: int) -> bool:
	if self.player_id == NO_PLAYER_ID:
		return true
	return self.player_id == player_id


func blow(from: Transform2D, force: float) -> void:
	var direction = (global_transform.origin - from.origin).normalized()
	velocity += direction * force


func _physics_process(delta: float) -> void:
	if (paused): return
	
	velocity *= FRICTION
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var hit = collision_info.get_collider()
		if hit is Bubble:
			var transferred_velocity = velocity / 2
			hit.velocity += transferred_velocity
			velocity = velocity.bounce(collision_info.get_normal())
			velocity /= 2
		else:
			velocity = velocity.bounce(collision_info.get_normal())


func pop():
	animated_sprite_2d.play("pop")
	pop_sound.pitch_scale = 1 + randf_range(0, 0.25)
	pop_sound.play()
	set_collision_layer_value(Enums.CollisionLayer.BUBBLES, false)
	velocity = Vector2.ZERO
	await get_tree().create_timer(5.0).timeout
	queue_free()


func collect():
	# sound / animation then delete
	queue_free()
