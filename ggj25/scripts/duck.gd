extends CharacterBody2D


@onready var blow_hitbox: ShapeCast2D = $BlowHitbox
@onready var sprite: Sprite2D = $Sprite2D

@export var sprites: Array[Texture2D]
@export var player_id: int = 0

enum Direction { DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT }
const SPEED = 200.0
const BLOW_FORCE = 20


var current_direction = Direction.DOWN

const COLOURS = [
	Color8(255, 252, 49), # Yellow
	Color8(255, 29, 21), # Red
	Color8(51, 124, 160), # Blue
	Color8(62, 195, 0), # Green (very)
]

func _ready() -> void:
	sprite.texture = sprites[0]
	sprite.modulate = COLOURS[player_id]
	print(player_id, Input.get_joy_info(player_id), Input.get_joy_name(player_id))


func with_deadzone(vector: Vector2, deadzone: float = 0.3) -> Vector2:
	if abs(vector.length()) < deadzone:
		return Vector2.ZERO
	return vector


func is_controller():
	return player_id in Input.get_connected_joypads()


func _physics_process(_delta: float) -> void:
	if is_controller():
		velocity = with_deadzone(Vector2(Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X), Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)))
	else:
		velocity = Input.get_vector("p%s_move_left" % player_id, "p%s_move_right" % player_id, "p%s_move_up" % player_id, "p%s_move_down" % player_id)
	
	velocity = velocity.normalized()
	set_direction(velocity.x, velocity.y)
	
	velocity *= SPEED

	
	if is_controller():
		if Input.is_joy_button_pressed(player_id, JOY_BUTTON_A):
			blow()
	else:
		if Input.is_action_pressed("p%s_blow" % player_id):
			blow()	
	
	sprite.texture = sprites[current_direction]

	move_and_slide()


func set_direction(x: float, y: float) -> void:
	if y > 0.25:
		if x < -0.25:
			current_direction = Direction.DOWN_LEFT
		elif x > 0.25:
			current_direction = Direction.DOWN_RIGHT
		else:
			current_direction = Direction.DOWN
	elif y < -0.25:
		if x < -0.25:
			current_direction = Direction.UP_LEFT
		elif x > 0.25:
			current_direction = Direction.UP_RIGHT
		else:
			current_direction = Direction.UP
	else:
		if x < 0:
			current_direction = Direction.LEFT
		elif x > 0:
			current_direction = Direction.RIGHT


func blow() -> void:
	if blow_hitbox.is_colliding():
		for i in range(blow_hitbox.get_collision_count()):
			var hit = blow_hitbox.get_collider(i)
			if "name" in hit:
				print('hit ', hit.name)
			if hit and hit.has_method("blow"):
				hit.call("blow", global_transform, BLOW_FORCE)
