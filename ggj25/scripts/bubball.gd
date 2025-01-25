extends Node2D

@onready var game_timer: Timer = $GameTimer
@onready var hud: Hud = $Hud

const GAME_TIME = 5

func _on_hud_start_game() -> void:
	print('Bubball Started!')
	game_timer.start(GAME_TIME)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_timer.wait_time = GAME_TIME
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hud.set_timer(str(game_timer.time_left))


func _on_game_timer_timeout() -> void:
	print('Game finished!')
