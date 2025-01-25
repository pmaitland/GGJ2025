class_name BubbleSpawner extends Node2D

@onready var timer: Timer = $Timer
@export var bubble_scene: PackedScene

enum SPAWNER_TYPE { MANUAL, TIMER }

@export var spawn_mode: SPAWNER_TYPE = SPAWNER_TYPE.MANUAL
@export var spawn_delay: float = 10

func spawn_bubble():
	var bubble: Bubble = bubble_scene.instantiate()
	add_child(bubble)


func _ready() -> void:
	if spawn_mode == SPAWNER_TYPE.TIMER:
		timer.wait_time = spawn_delay
		timer.start()


func _on_timer_timeout() -> void:
	spawn_bubble()
