class_name GameMode extends Node2D

@onready var hud: Hud = $Hud
@onready var game_timer: Timer = $GameTimer

@export var GAME_TIME = 60
@export var OVERTIME_ENABLED: bool = true
@export var TEAMS_ENABLED: bool = true
@export var TEAM_COUNT: int = 2

var ducks: Array[Duck]
var initial_positions: Array[Vector2]
var bubbles: Array[Bubble]
var scores: Array[int]  # key: team_id, value: score
var teams: Dictionary  # key: player_id, value: team_id

var started = false
var paused = false

enum {
	LEFT_TEAM,
	RIGHT_TEAM,
}

const TEAM_ID_GAME_TIED = -1


func _ready() -> void:
	connect("player_joined", _on_player_joined)
	connect("player_left", _on_player_left)
	
	find_ducks()
	find_bubbles()
	enable_duck_input(false)
	init_teams()
	if game_timer:
		game_timer.wait_time = GAME_TIME
		if hud:
			hud.set_timer(format_timer(game_timer.wait_time))
	if hud:
		hud.setup_game()


func get_team_count() -> int:
	if is_team_game():
		return TEAM_COUNT
	return ducks.size()


func _on_player_joined(player_id: int) -> void:
	if not is_team_game():
		init_teams()


func _on_player_left(player_id: int) -> void:
	if not is_team_game():
		init_teams()


func init_team_scores():
	scores = []
	scores.resize(get_team_count())
	scores.fill(0)
	
	
func init_teams() -> void: 
	init_team_scores()
	var no_of_teams = get_team_count()
	
	teams = {}
	
	# TODO: allow players to choose team instead of auto assign
	var next_team_id = 0
	for i in range(ducks.size()):
		teams[ducks[i].player_id] = next_team_id
		ducks[i].set_team_id(next_team_id)
		next_team_id = (next_team_id + 1) % no_of_teams


func _process(delta: float) -> void:
	if started:
		# handle pause
		if Input.is_action_just_pressed("game_pause"):
			toggle_pause()
		
		# Update HUD scores
		if hud:
			update_scoreboard()
			
		# Update HUD game timer
		if hud and game_timer:
			hud.set_timer(format_timer(game_timer.time_left))


func update_scoreboard():
	hud.set_left_score(scores[LEFT_TEAM])
	hud.set_right_score(scores[RIGHT_TEAM])


func start_game():
	game_timer.start(GAME_TIME)
	started = true
	enable_duck_input(true)


func finish_game():
	if started:
		print('Game finished!')
		started = false
		enable_duck_input(false)
		
		if hud:
			if is_tie():
				hud.show_game_end(TEAM_ID_GAME_TIED)
			else:
				var winning_team = get_winning_team()
				hud.show_game_end(winning_team, get_team_name(winning_team))


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
	
	return str(int(ceil(time_left)))


func get_team(player_id: int) -> int:
	return teams[player_id]


func get_players(team_id: int) -> Array[int]:
	var result: Array[int] = []
	for player_id in teams:
		if teams[player_id] == team_id:
			result.append(player_id)
	return result


func get_opposing_team(player_id: int) -> int:
	assert(is_team_game(), "Can't get opposing team when not team game")
	assert(scores.size() == 2, "Can't get opposing team when not exactly 2 teams")
	return (get_team(player_id) + 1) % 2


func validate_team_id(team_id: int) -> bool:
	if team_id >= 0 and team_id < scores.size():
		return true
	push_error("Team %s doesn't exist" % team_id)
	return false


func add_score(team_id: int, score: int = 1) -> void:
	if validate_team_id(team_id):
		scores[team_id] += score


func is_team_game() -> bool:
	return TEAMS_ENABLED


func get_team_name(team_id: int) -> String:
	if !validate_team_id(team_id):
		return "Missing team name"
	
	if not is_team_game():
		return PlayerManager.get_player_name(get_players(team_id)[0])
	
	if get_team_count() > 2:
		push_error("Team names not set for >2 teams")
		return "Missing team name"

	match team_id:
		LEFT_TEAM:
			return "Left Team"
		RIGHT_TEAM:
			return "Right Team"
	
	return "Missing team name"


func _is_tie(winning_teams: Array[int]) -> bool:
	return winning_teams.size() > 1


func is_tie() -> bool:
	return _is_tie(get_all_winning_teams())


func get_all_winning_teams() -> Array[int]:
	var teams_with_winning_score: Array[int] = []
	var winning_score = get_winning_score()
	for team_id in range(scores.size()):
		if scores[team_id] == winning_score:
			teams_with_winning_score.append(team_id)
	return teams_with_winning_score


func get_winning_score() -> int:
	# default higher score = winning
	return scores.max()


func get_winning_team() -> int:
	var winning_teams = get_all_winning_teams()
	if _is_tie(winning_teams):
		return TEAM_ID_GAME_TIED
	
	return winning_teams[0]
