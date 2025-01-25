class_name Duck extends CharacterBody2D


@onready var blow_hitbox: ShapeCast2D = $BlowHitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var sprites: Array[Texture2D]
@export var player_id: int = 0

enum Direction { DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT }
const SPEED = 250.0
const ACCELERATION = 10
const BLOW_FORCE = 20

var input_enabled = true

const DASH_DURATION = 0.07
const DASH_SPEED = SPEED * 5
const DASH_COOLDOWN = 0.5
const DASH_ACCELERATION = ACCELERATION * 20
var is_dashing = false
var dash_available = true
var last_direction = Vector2.DOWN

var dash_controller_pressed = false

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


func set_input_enabled(enabled: bool):
	input_enabled = enabled


func is_controller():
	return player_id in Input.get_connected_joypads()


func _process(delta: float) -> void:
	if !Input.is_joy_button_pressed(player_id, JOY_BUTTON_A): dash_controller_pressed = false
	

func _physics_process(_delta: float) -> void:
	if (!input_enabled): return

	var direction = get_input_direction() if not is_dashing else last_direction

	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
	
	set_direction(direction.x, direction.y)
	var desired_velocity = direction * (DASH_SPEED if is_dashing else SPEED)
	velocity = velocity.move_toward(desired_velocity, (ACCELERATION if velocity.length() <= SPEED and not is_dashing else DASH_ACCELERATION))
	
	
	if is_controller():
		if Input.get_joy_axis(player_id, JOY_AXIS_TRIGGER_RIGHT) > 0.3: 
			blow()
	else:
		if Input.is_action_pressed("p%s_blow" % player_id):
			blow()	
	
	
	if is_controller():
		if Input.is_joy_button_pressed(player_id, JOY_BUTTON_A) and !dash_controller_pressed:
			dash_controller_pressed = true
			dash()
	else:
		if Input.is_action_just_pressed("p%s_dash" % player_id):
			dash()
	
	sprite.texture = sprites[current_direction]

	move_and_slide()


func dash():
	if dash_available:
		is_dashing = true
		dash_available = false
		dash_timer.start(DASH_DURATION)
		dash_cooldown.start(DASH_COOLDOWN)
		audio_stream_player.pitch_scale = 1 + randf_range(0, 0.25)
		audio_stream_player.play()
	

func get_input_direction():
	if is_controller():
		return with_deadzone(Vector2(Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X), Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y))).normalized()
	return Input.get_vector("p%s_move_left" % player_id, "p%s_move_right" % player_id, "p%s_move_up" % player_id, "p%s_move_down" % player_id).normalized()
	


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
				pass
			if hit and hit.has_method("blow"):
				hit.call("blow", global_transform, BLOW_FORCE)


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func _on_dash_cooldown_timeout() -> void:
	dash_available = true
