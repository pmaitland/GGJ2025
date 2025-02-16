extends GameMode

@onready var bubble_spawner: BubbleSpawner = $BubbleSpawner


func _on_hud_start_game() -> void:
	start_game()
	print('DODGE BUBBALL Started!')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	# Add game specific code here...


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	# Add game specific code here...


func _on_game_timer_timeout() -> void:
	finish_game()


func on_score():
	for duck in ducks:
		if duck != null:
			duck.goal_scored()
	await get_tree().create_timer(1.0).timeout
	bubbles = [bubble_spawner.spawn_bubble()]


func _on_duck_collided_with_bubble(duck: Duck, bubble: Bubble) -> void:
	var team_id = get_opposing_team(duck.player_id)
	add_score(team_id)
	hud.show_scores_message(get_team_name(team_id))
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


func _on_hud_unpause_game() -> void:
	toggle_pause()
