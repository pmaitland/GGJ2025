extends CanvasLayer

@onready var countdown_message: Label = $CountdownMessage
@onready var countdown_message_timer: Timer = $CountdownMessageTimer
@onready var start_button: Button = $StartButton
@onready var left_score: Label = $HBoxContainer/LeftScore
@onready var right_score: Label = $HBoxContainer/RightScore

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text: String) -> void:
	countdown_message.text = text
	countdown_message.show()
	countdown_message_timer.start()

func show_game_over() -> void:
	show_message("Game Over")
	# Wait until the CountdownMessageTimer has counted down.
	await countdown_message_timer.timeout

func show_game_start() -> void:
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

func hide_message() -> void:
	countdown_message.hide()

func hide_start_button() -> void:
	start_button.hide()

func _on_start_button_pressed() -> void:
	hide_start_button()
	start_game.emit()
	show_game_start()

func set_left_score(score: int) -> void:
	left_score.text = str(score)

func set_right_score(score: int) -> void:
	right_score.text = str(score)

