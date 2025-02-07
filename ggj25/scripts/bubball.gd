extends GameMode

@onready var bubble_spawner: BubbleSpawner = $BubbleSpawner

const GAME_TIME = 60

var left_team_score = 0
var right_team_score = 0


func _on_hud_start_game() -> void:
	print('Bubball Started!')
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
	if started:
		hud.set_timer(format_timer(game_timer.time_left))
		hud.set_left_score(left_team_score)
		hud.set_right_score(right_team_score)



func pause() -> void:
	super.pause()
	print('child pause')


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


func _on_left_goal_bubble_collected(team_id: int) -> void:
	if started:
		hud.show_message("RIGHT TEAM SCORES!")
		right_team_score += 1
		on_goal_scored()


func _on_right_goal_bubble_collected(team_id: int) -> void:
	if started:
		hud.show_message("LEFT TEAM SCORES!")
		left_team_score += 1
		on_goal_scored()


func on_goal_scored():
	for duck in ducks:
		if duck != null:
			duck.goal_scored()
	
	game_timer.set_paused(true)

	enable_duck_input(false)
	await get_tree().create_timer(2.0).timeout
	
	if !paused:
		hud.show_message("Get Ready!")
	# Reset duck positions
	reset_duck_positions()
	bubbles = [bubble_spawner.spawn_bubble()]
	await get_tree().create_timer(1.0).timeout
	
	if paused:
		hud.show_game_pause()
		return
		
	hud.show_message("Go!")
	game_timer.set_paused(false)
	enable_duck_input(true)
		
	await get_tree().create_timer(0.6).timeout
	hud.hide_message()
