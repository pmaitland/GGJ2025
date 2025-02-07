extends GameMode

@onready var bubble_spawner: BubbleSpawner = $BubbleSpawner

const GAME_TIME = 60

var left_team_score = 0
var right_team_score = 0


func _on_hud_start_game() -> void:
	print('DODGE BUBBALL Started!')
	game_timer.start(GAME_TIME)
	started = true
	enable_duck_input(true)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	game_timer.wait_time = GAME_TIME
	hud.set_timer(str(GAME_TIME))
	hud.setup_game()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	# xD this is the same code as in bubball.gd
	if started:
		hud.set_timer(format_timer(game_timer.time_left))
		hud.set_left_score(left_team_score)
		hud.set_right_score(right_team_score)


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
	bubbles = [bubble_spawner.spawn_bubble()]


func enable_duck_input(enable, node: Node = self):
	for duck in ducks:
		if duck != null:
			duck.set_input_enabled(enable)
			print('Setting input for ', duck.name, enable)


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
	reset_duck_positions()
				
	if !paused:
		enable_duck_input(true)
	else:
		hud.show_game_pause()
