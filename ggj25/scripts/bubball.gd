extends GameMode

@onready var bubble_spawner: BubbleSpawner = $BubbleSpawner


func _on_hud_start_game() -> void:
	start_game()
	print('BUBBAL Started!')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	# Add game specific code here
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	# add game specific code here


func _on_game_timer_timeout() -> void:
	finish_game()


func _on_left_goal_bubble_collected(_bubble: Bubble) -> void:
	if started:
		on_goal_scored(RIGHT_TEAM)


func _on_right_goal_bubble_collected(_bubble: Bubble) -> void:
	if started:
		on_goal_scored(LEFT_TEAM)


func on_goal_scored(team_id: int):
	hud.show_scores_message(get_team_name(team_id))
	add_score(team_id)
	
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
