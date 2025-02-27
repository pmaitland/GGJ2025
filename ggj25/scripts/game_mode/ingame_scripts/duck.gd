class_name Duck extends CharacterBody2D


@onready var blow_hitbox: ShapeCast2D = $BlowHitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var quack_sound: AudioStreamPlayer = $QuackSound
@onready var dash_sound: AudioStreamPlayer = $DashSound
@onready var blow_animations: Node2D = $BlowAnimations
@onready var dash_animation: AnimatedSprite2D = $dashparent/DashAnimation
@onready var dashparent: Node2D = $dashparent
@onready var dash_hitbox: ShapeCast2D = $dashparent/DashHitbox

@export var sprites: Array[Texture2D]
@export var player_id: int = 0
@export var team_id: int = 0

enum Direction { DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT }
const SPEED = 250.0
const ACCELERATION = 10
const BLOW_FORCE = 20
const DASH_FORCE = 400

var input_enabled = true

const DASH_DURATION = 0.1
const DASH_SPEED = SPEED * 5
const DASH_COOLDOWN = 0.5
const DASH_ACCELERATION = ACCELERATION * 20
var is_dashing = false
var dash_available = true
var last_direction = Vector2.DOWN

var current_direction = Direction.DOWN

var blow_animation_playing = false
const blow_animation_duration = 39
var blow_animation_current_duration = 0

signal collided_with_bubble

var quacking = false
const QUACK_COOLDOWN = 20
var quack_duration = 0
	

func init_colors() -> void:
	sprite.texture = sprites[0]
	sprite.material.set_shader_parameter("body_colour", Constants.DUCK_COLOURS[player_id]) 
	sprite.material.set_shader_parameter("line_color", Constants.TEAM_COLOURS[team_id])
	dash_animation.modulate = Constants.DUCK_COLOURS[player_id]
	
func _ready() -> void:
	if !PlayerManager.is_joined(player_id):
		queue_free()
	print(player_id, Input.get_joy_info(player_id), Input.get_joy_name(player_id))
	for _i in blow_animations.get_children():
		_i.modulate = Constants.DUCK_COLOURS[player_id]
		_i.play("default")


func set_team_id(_team_id) -> void:
	team_id = _team_id
	init_colors()
	print("{name} assigned to team id: {team_id}".format({"name": PlayerManager.get_player_name(player_id), "team_id":team_id}))
	
func with_deadzone(vector: Vector2, deadzone: float = 0.3) -> Vector2:
	if abs(vector.length()) < deadzone:
		return Vector2.ZERO
	return vector


func set_input_enabled(enabled: bool):
	input_enabled = enabled


func is_controller():
	return player_id in Input.get_connected_joypads()


func _process(delta: float) -> void:
	visible = PlayerManager.is_joined(player_id)
	

func _physics_process(_delta: float) -> void:
	if (!PlayerManager.is_joined(player_id)): return
	
	var direction = get_input_direction() if not is_dashing else last_direction

	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
	
	set_direction(last_direction.x, last_direction.y)
	var desired_velocity = direction * (DASH_SPEED if is_dashing else SPEED)
	velocity = velocity.move_toward(desired_velocity, (ACCELERATION if velocity.length() <= SPEED and not is_dashing else DASH_ACCELERATION))
	
	
	if Input.is_action_pressed("p%s_blow" % player_id):
		blow()	
	
	if Input.is_action_just_pressed("p%s_dash" % player_id):
		dash()
	
	sprite.texture = sprites[current_direction]
	
	if blow_animation_playing:
		if blow_animation_current_duration > blow_animation_duration:
			blow_animation_playing = false
			blow_animation_current_duration = 0
			blow_animations.visible = false
		blow_animation_current_duration += 1
		
	quack_duration += 1

	if input_enabled:
		move_and_slide()


func dash():
	if dash_available and input_enabled:
		is_dashing = true
		dash_available = false
		dash_timer.start(DASH_DURATION)
		dash_cooldown.start(DASH_COOLDOWN)
		Input.start_joy_vibration(player_id, 0, 0.6, DASH_DURATION)
		dash_animation.play("default", 2)
		dash_sound.pitch_scale = 1 + randf_range(0, 0.25)
		dash_sound.play()
		
		if dash_hitbox.is_colliding():
			for i in range(dash_hitbox.get_collision_count()):
				var hit = dash_hitbox.get_collider(i)
				if "name" in hit:
					pass
				if hit and hit.has_method("blow"):
					hit.call("blow", global_transform, DASH_FORCE)
	

func get_input_direction():
	return Input.get_vector("p%s_move_left" % player_id, "p%s_move_right" % player_id, "p%s_move_up" % player_id, "p%s_move_down" % player_id).normalized()
	


func set_dash_direction(rot_degress: int):
	if not dash_animation.is_playing():
		dashparent.rotation_degrees = rot_degress


func set_direction(x: float, y: float) -> void:
	
	if y > 0.25:
		if x < -0.25:
			current_direction = Direction.DOWN_LEFT
			set_dash_direction(315)
		elif x > 0.25:
			current_direction = Direction.DOWN_RIGHT
			set_dash_direction(225)
		else:
			current_direction = Direction.DOWN
			set_dash_direction(270)
	elif y < -0.25:
		if x < -0.25:
			current_direction = Direction.UP_LEFT
			set_dash_direction(45)
		elif x > 0.25:
			current_direction = Direction.UP_RIGHT
			set_dash_direction(135)
		else:
			current_direction = Direction.UP
			set_dash_direction(90)
	else:
		if x < 0:
			current_direction = Direction.LEFT
			set_dash_direction(0)
		elif x > 0:
			current_direction = Direction.RIGHT
			set_dash_direction(180)


func blow() -> void:
	blow_animation_playing = true
	blow_animations.visible = true
	var hit_bubble = false
	if input_enabled:
		quack()
		if blow_hitbox.is_colliding():
			for i in range(blow_hitbox.get_collision_count()):
				var hit = blow_hitbox.get_collider(i)
				if not hit:
					continue
					
				if hit.has_method("can_be_blown_by") and not hit.call("can_be_blown_by", player_id):
					continue
				
				if hit.has_method("blow"):
					hit_bubble = true
					hit.call("blow", global_transform, BLOW_FORCE)
	
	if hit_bubble:
		Input.start_joy_vibration(player_id, 0.2, 0, 0.02)
	else:
		Input.start_joy_vibration(player_id, 0.05, 0, 0.02)


func quack():
	if quacking:
		if quack_duration > QUACK_COOLDOWN:
			quacking = false
	else:
		quack_sound.pitch_scale = 1 + randf_range(0, 0.25)
		quack_sound.play()
		quacking = true
		quack_duration = 0

func goal_scored():
	Input.start_joy_vibration(player_id, 0.5, 0.5, 1)


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func _on_dash_cooldown_timeout() -> void:
	dash_available = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Bubble:
		collided_with_bubble.emit(self, body as Bubble)
		
func die_and_flash():
	sprite.modulate = Color8(220,220,220)
	
	for i in range(0,8):
		await get_tree().create_timer(0.0625).timeout
		sprite.visible = false
		await get_tree().create_timer(0.0625).timeout
		sprite.visible = true
	
func revive():
	init_colors()
