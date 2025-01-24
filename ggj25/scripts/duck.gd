extends CharacterBody2D


@onready var blow_hitbox: ShapeCast2D = $BlowHitbox
@onready var sprite: Sprite2D = $Sprite2D


@export var sprites: Array[Texture2D]


enum Direction { DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT }
const SPEED = 200.0
const BLOW_FORCE = 20


var current_direction = Direction.DOWN


func _ready() -> void:
	sprite.texture = sprites[0]


func _physics_process(_delta: float) -> void:
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

	set_direction(x_direction, y_direction)
	
	sprite.texture = sprites[current_direction]

	move_and_slide()


func set_direction(x: float, y: float) -> void:
	if y > 0:
		if x < 0:
			current_direction = Direction.DOWN_LEFT
		elif x > 0:
			current_direction = Direction.DOWN_RIGHT
		else:
			current_direction = Direction.DOWN
	elif y < 0:
		if x < 0:
			current_direction = Direction.UP_LEFT
		elif x > 0:
			current_direction = Direction.UP_RIGHT
		elif x == 0:
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
