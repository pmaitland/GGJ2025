class_name Hud extends CanvasLayer

#UI
@onready var left_score: Label = $TopSection/HBoxContainer/LeftScore
@onready var right_score: Label = $TopSection/HBoxContainer/RightScore
@onready var game_timer: Label = $TopSection/HBoxContainer/Timer
@onready var countdown_message: Label = $CountdownMessage
@onready var controls_hud: CanvasLayer = $ControlsHUD
@onready var settings_hud: CanvasLayer = $SettingsHUD
@onready var top_section: MarginContainer = $TopSection
@onready var middle_section: MarginContainer = $MiddleSection

#Buttons
@onready var start_button: Button = $MiddleSection/GameStartButtons/StartButton
@onready var retry_button: Button = $MiddleSection/GameEndButtons/RetryButton
@onready var main_menu_button: Button = $MiddleSection/GameEndButtons/MainMenuButton
@onready var controls: Button = $MiddleSection/GamePauseButtons/Controls
@onready var settings: Button = $MiddleSection/GamePauseButtons/Settings
@onready var exit: Button = $MiddleSection/GamePauseButtons/Exit


@onready var game_start_buttons: VBoxContainer = $MiddleSection/GameStartButtons
@onready var game_end_buttons: VBoxContainer = $MiddleSection/GameEndButtons
@onready var game_pause_buttons: VBoxContainer = $MiddleSection/GamePauseButtons


@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var countdown_sound: AudioStreamPlayer = $CountdownSound
@onready var start_sound: AudioStreamPlayer = $StartSound

@export var game_mode: int = 0 # 0 for football, 1 for dodge ball

# Notifies `Main` node that the button has been pressed
signal start_game
signal unpause_game

func _ready():
	start_button.grab_focus()

func show_message(text: String) -> void:
	countdown_message.text = text
	countdown_message.show()


func show_scores_message(team_name: String) -> void:
	show_message(("%s SCORES!" % team_name).to_upper())


func setup_game() -> void:
	left_score.text = "0"
	right_score.text = "0"
	game_timer.modulate = Color(1, 1, 1, 1)
	game_start_buttons.show()
	game_end_buttons.hide()
	game_pause_buttons.hide()

func show_game_start() -> void:
	show_message("Get Ready!")
	await get_tree().create_timer(1.0).timeout
	show_message("3")
	countdown_sound.play()
	await get_tree().create_timer(1.0).timeout
	show_message("2")
	countdown_sound.play()
	await get_tree().create_timer(1.0).timeout
	show_message("1")
	countdown_sound.play()
	await get_tree().create_timer(1.0).timeout
	show_message("Go!")
	start_game.emit()
	start_sound.play()
	await get_tree().create_timer(0.7).timeout
	hide_message()
	game_start_buttons.hide()
	audio_stream_player.play()

func show_game_pause() -> void:
	left_score.modulate.a = 0.75
	right_score.modulate.a = 0.75
	game_timer.modulate.a = 0.75
	show_message("Game Paused")
	game_pause_buttons.show()
	settings.grab_focus()
	

func hide_game_pause() -> void:
	left_score.modulate.a = 1
	right_score.modulate.a = 1
	game_timer.modulate.a = 1
	game_pause_buttons.hide()
	hide_message()

func show_game_end(win_team: int, team_name: String = "") -> void:
	game_timer.modulate = Color(1, 0, 0, 1)
	show_message("Finish!")
	await get_tree().create_timer(1.0).timeout
	if win_team == GameMode.TEAM_ID_GAME_TIED:
		show_message("It's a Draw!")
	else:
		show_message("%s Wins!" % team_name)
	game_end_buttons.show()
	retry_button.grab_focus()

func hide_message() -> void:
	countdown_message.hide()

func set_left_score(score: int) -> void:
	left_score.text = str(score)

func set_right_score(score: int) -> void:
	right_score.text = str(score)

func set_timer(time: String) -> void:
	game_timer.text = time

func _on_start_button_pressed() -> void:
	game_start_buttons.hide()
	PlayerManager.set_joining_enabled(false)
	show_game_start()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameModeSelection.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainScreen.tscn")


func _on_retry_button_pressed() -> void:
	if game_mode == 0: get_tree().change_scene_to_file("res://scenes/bubbal_game.tscn")
	elif game_mode == 1: get_tree().change_scene_to_file("res://scenes/dodge_bubbal.tscn")


func _on_controls_pressed() -> void:
	top_section.hide()
	middle_section.hide()
	countdown_message.hide()
	controls_hud.show()


func _on_settings_pressed() -> void:
	top_section.hide()
	middle_section.hide()
	countdown_message.hide()
	settings_hud.show()



func _on_controls_hud_go_back() -> void:
	controls_hud.hide()
	top_section.show()
	middle_section.show()
	countdown_message.show()

func _on_settings_hud_go_back() -> void:
	settings_hud.hide()
	top_section.show()
	middle_section.show()
	countdown_message.show()


func _on_continue_pressed() -> void:
	unpause_game.emit()
