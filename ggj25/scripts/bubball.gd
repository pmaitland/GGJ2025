extends Node2D

@onready var game_timer: Timer = $GameTimer
@onready var hud: Hud = $Hud

const GAME_TIME = 20
var started = false

var left_team_score = 0
var right_team_score = 0

func _on_hud_start_game() -> void:
	print('Bubball Started!')
	game_timer.start(GAME_TIME)
	started = true
	enable_duck_input(true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_timer.wait_time = GAME_TIME
	hud.set_timer(str(GAME_TIME))
	enable_duck_input(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started:
		hud.set_timer(format_timer(game_timer.time_left))
		hud.set_left_score(left_team_score)
		hud.set_right_score(right_team_score)
		

func format_timer(time_left: float) -> String:
	if time_left < 10:
		return str(snappedf(time_left, 0.1))
	
	return str(ceil(time_left))



func _on_game_timer_timeout() -> void:
	# NOEL ADD END GAME STUFF HERE PLZ
	
	print('Game finished!')
	enable_duck_input(false)
	hud.set_timer("0")
	started = false


func _on_left_goal_bubble_collected(team_id: int) -> void:
	if started:
		right_team_score += 1


func _on_right_goal_bubble_collected(team_id: int) -> void:
	if started:
		left_team_score += 1

func enable_duck_input(enable, node: Node = self):	
	if node is Duck:
		print('Setting input for ', node.name, enable)
		(node as Duck).set_input_enabled(enable)
	for n in node.get_children():
		enable_duck_input(enable, n)
