class_name Hud extends CanvasLayer

#UI
@onready var left_score: Label = $HBoxContainer/LeftScore
@onready var right_score: Label = $HBoxContainer/RightScore
@onready var game_timer: Label = $HBoxContainer/Timer
@onready var countdown_message: Label = $CountdownMessage
#Buttons
@onready var start_button: Button = $StartButton
@onready var retry_button: Button = $MarginContainer2/GameEndButtons/RetryButton
@onready var main_menu_button: Button = $MarginContainer2/GameEndButtons/MainMenuButton
@onready var controls: Button = $MarginContainer2/GamePauseButtons/Controls
@onready var settings: Button = $MarginContainer2/GamePauseButtons/Settings
@onready var exit: Button = $MarginContainer2/GamePauseButtons/Exit


@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text: String) -> void:
	countdown_message.text = text
	countdown_message.show()

func show_game_start() -> void:
	start_button.show()
	show_message("Get Ready!")
	await get_tree().create_timer(1.0).timeout
	show_message("3")
	await get_tree().create_timer(1.0).timeout
	show_message("2")
	await get_tree().create_timer(1.0).timeout
	show_message("1")
	await get_tree().create_timer(1.0).timeout
	show_message("Go!")
	await get_tree().create_timer(1.0).timeout
	hide_message()
	hide_start_button()
	start_game.emit()
	audio_stream_player.play()

func show_game_pause() -> void:
	left_score.modulate.a = 0.75
	right_score.modulate.a = 0.75
	game_timer.modulate.a = 0.75
	show_message("Game Paused")
	controls.show()
	settings.show()
	exit.show()

func hide_game_pause() -> void:
	left_score.modulate.a = 1
	right_score.modulate.a = 1
	game_timer.modulate.a = 1
	controls.hide()
	settings.hide()
	exit.hide()
	hide_message()

func show_game_end(win_team: int) -> void:
	game_timer.modulate = Color(1, 0, 0, 1)
	show_message("Finish!")
	await get_tree().create_timer(1.0).timeout
	show_message("Team " + str(win_team) + " Wins!")
	retry_button.show()
	main_menu_button.show()

func hide_message() -> void:
	countdown_message.hide()

func hide_start_button() -> void:
	start_button.hide()

func set_left_score(score: int) -> void:
	left_score.text = str(score)

func set_right_score(score: int) -> void:
	right_score.text = str(score)

func set_timer(time: String) -> void:
	game_timer.text = time

func _on_start_button_pressed() -> void:
	hide_start_button()
	show_game_start()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameModeSelection.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainScreen.tscn")


func _on_retry_button_pressed() -> void:
	pass # Replace with function body.


func _on_controls_pressed() -> void:
	SceneManager.go_to_scene("res://scenes/ControlsScreen.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.
