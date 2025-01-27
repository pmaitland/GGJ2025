extends Node2D

@onready var game_timer: Timer = $GameTimer
@onready var hud: Hud = $Hud
@onready var bubble_spawner: BubbleSpawner = $BubbleSpawner
@onready var bubble: Bubble = $Bubble

const GAME_TIME = 60
var started = false

var left_team_score = 0
var right_team_score = 0


var ducks: Array[Duck]
var initial_positions: Array[Vector2]

func _on_hud_start_game() -> void:
	print('DODGE BUBBALL Started!')
	game_timer.start(GAME_TIME)
	started = true
	enable_duck_input(true)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_timer.wait_time = GAME_TIME
	hud.set_timer(str(GAME_TIME))
	hud.setup_game()
	ducks = find_ducks()
	enable_duck_input(false)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# xD this is the same code as in bubball.gd
	if started:
		hud.set_timer(format_timer(game_timer.time_left))
		hud.set_left_score(left_team_score)
		hud.set_right_score(right_team_score)
		
	# handle pause
	if Input.is_action_just_pressed("game_pause"):
		if game_timer.is_paused():
			game_timer.set_paused(false)
			hud.hide_game_pause()
			enable_duck_input(true)
			bubble.set_paused(false)
		else:
			game_timer.set_paused(true)
			hud.show_game_pause()
			enable_duck_input(false)
			bubble.set_paused(true)


func format_timer(time_left: float) -> String:
	if time_left < 10:
		return str(snappedf(time_left, 0.1))
	
	return str(ceil(time_left))


func _on_game_timer_timeout() -> void:
	if started:
		print('Game finished!')
		enable_duck_input(false)
		hud.set_timer("0")
		started = false
		hud.show_game_end(get_winning_team())


func get_winning_team() -> int:
	if left_team_score > right_team_score:
		return 1
	elif right_team_score > left_team_score:
		return 2
	else:
		return 0


func on_score():
	for duck in ducks:
		if duck != null:
			duck.goal_scored()
	await get_tree().create_timer(1.0).timeout
	bubble = bubble_spawner.spawn_bubble()

func enable_duck_input(enable, node: Node = self):
	for duck in ducks:
		if duck != null:
			duck.set_input_enabled(enable)
			print('Setting input for ', duck.name, enable)
		
func find_ducks() -> Array[Duck]:
	var result: Array[Duck] = []
	for n in self.get_children():
		if n is Duck:
			result.append(n as Duck)
			initial_positions.append(n.position)
	return result


func _on_duck_collided_with_bubble(duck: Duck, bubble: Bubble) -> void:
	if(duck.player_id % 2 == 0): # Team 0
		right_team_score += 1
		hud.show_message("RIGHT TEAM SCORES!")
	else: # Team 1
		left_team_score += 1
		hud.show_message("LEFT TEAM SCORES!")
	bubble.pop()
	on_score()
	
	enable_duck_input(false)
	duck.die_and_flash()
	await get_tree().create_timer(1.0).timeout
	duck.revive()
	hud.hide_message()
	
	# Reset duck positions
	for i in range(0, ducks.size()):
		print(i)
		if ducks[i] != null:
			ducks[i].position = initial_positions[i]
				
	enable_duck_input(true)
