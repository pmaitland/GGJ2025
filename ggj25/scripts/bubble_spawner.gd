extends Node


@export var bubble_scene: PackedScene

func spawn_bubble():
	var bubble = bubble_scene.instantiate()
