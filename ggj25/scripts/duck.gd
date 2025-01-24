extends CharacterBody2D


@export var sprites: Array[Texture2D]


enum Direction { DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT, RIGHT, DOWN_RIGHT }
const SPEED = 300.0

var sprite: Sprite2D
var currentDirection = Direction.DOWN


func _ready() -> void:
	sprite = get_node("Sprite2D")
	sprite.texture = sprites[0]


func _physics_process(_delta: float) -> void:
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

	set_direction(x_direction, y_direction)
	
	sprite.texture = sprites[currentDirection]

	move_and_slide()


func set_direction(x: float, y: float) -> void:
	if y > 0:
		if x < 0:
			currentDirection = Direction.DOWN_LEFT
		elif x > 0:
			currentDirection = Direction.DOWN_RIGHT
		else:
			currentDirection = Direction.DOWN
	elif y < 0:
		if x < 0:
			currentDirection = Direction.UP_LEFT
		elif x > 0:
			currentDirection = Direction.UP_RIGHT
		elif x == 0:
			currentDirection = Direction.UP
	else:
		if x < 0:
			currentDirection = Direction.LEFT
		elif x > 0:
			currentDirection = Direction.RIGHT
