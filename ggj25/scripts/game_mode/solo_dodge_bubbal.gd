extends GameMode

var spawners: Array[BubbleSpawner]


func _on_hud_start_game() -> void:
	start_game()
	print('SOLO DODGE BUBBALL Started!')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	var joined_players = PlayerManager.get_joined_players()
	for spawner_node in find_children("*", "BubbleSpawner"):
		var bubble_spawner = spawner_node as BubbleSpawner
		if not joined_players.has(bubble_spawner.player_id):
			bubble_spawner.queue_free()
			continue
		spawners.append(bubble_spawner)
	
	respawn_bubbles()


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
	respawn_bubbles()


func respawn_bubbles():
	for bubble in bubbles:
		bubble.queue_free()
	
	bubbles = []
	for spawner in spawners:
		bubbles.append(spawner.spawn_bubble())


func _on_duck_collided_with_bubble(duck: Duck, bubble: Bubble) -> void:
	var player_id = bubble.player_id
	if duck.player_id == player_id:
		return
	
	add_score(player_id)
	hud.show_scores_message(get_team_name(player_id))
	bubble.pop()
	
	for other_bubble in bubbles:
		other_bubble.velocity = Vector2.ZERO
	
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
