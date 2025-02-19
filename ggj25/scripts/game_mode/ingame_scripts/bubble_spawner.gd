class_name BubbleSpawner extends Node2D

@onready var timer: Timer = $Timer
@export var bubble_scene: PackedScene

enum SPAWNER_TYPE { MANUAL, TIMER }

@export var spawn_mode: SPAWNER_TYPE = SPAWNER_TYPE.MANUAL
@export var spawn_delay: float = 10

@export var team_id: int = -1


func spawn_bubble() -> Bubble:
	var bubble: Bubble = bubble_scene.instantiate()
	bubble.set_team_id(team_id)
	add_child(bubble)
	return bubble


func _ready() -> void:
	if spawn_mode == SPAWNER_TYPE.TIMER:
		timer.wait_time = spawn_delay
		timer.start()


func _on_timer_timeout() -> void:
	spawn_bubble()
