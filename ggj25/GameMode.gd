class_name GameMode extends Node2D

@onready var hud: Hud = $Hud
@onready var game_timer: Timer = $GameTimer

var ducks: Array[Duck]
var initial_positions: Array[Vector2]
var bubbles: Array[Bubble]

var started = false
var paused = false


func _ready() -> void:
	find_ducks()
	enable_duck_input(false)
	find_bubbles()


func _process(delta: float) -> void:
	if started:
		# handle pause
		if Input.is_action_just_pressed("game_pause"):
			toggle_pause()


func toggle_pause():
	if paused:
		unpause()
	else:
		pause()


func pause():
	paused = true
	if game_timer:
		game_timer.set_paused(true)
	if hud:
		hud.show_game_pause()
	enable_duck_input(false)
	set_all_paused(bubbles, true)


func unpause():
	paused = false
	if game_timer:
		game_timer.set_paused(false)
	if hud:
		hud.hide_game_pause()
	enable_duck_input(true)
	set_all_paused(bubbles, false)


func enable_duck_input(enable: bool):
	for duck in ducks:
		if duck != null:
			duck.set_input_enabled(enable)
			print('Setting input for ', duck.name, enable)
		
		
func find_ducks() -> void:
	ducks = []
	var duck_nodes = find_children("*", "Duck")
	for i in range(0, duck_nodes.size()):
		var duck = duck_nodes[i] as Duck
		ducks.append(duck)
		initial_positions.append(duck.position)


func find_bubbles() -> void:
	bubbles = []
	for n in find_children("*", "Bubble"):
		bubbles.append(n as Bubble)


func reset_duck_positions():
	for i in range(min(ducks.size(), initial_positions.size())):
		if ducks[i] != null:
			ducks[i].position = initial_positions[i]


func set_all_paused(arr: Array, value: bool) -> void:
	for node in arr:
		set_node_paused(node, value)


func set_node_paused(node: Node, value: bool) -> void:
	if node.has_method("set_paused"):
		node.call("set_paused", value)


func format_timer(time_left: float) -> String:
	if time_left < 10:
		return str(snappedf(time_left, 0.1))
	
	return str(ceil(time_left))
