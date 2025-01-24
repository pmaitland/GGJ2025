extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game


func show_message(text: String) -> void:
	$CountdownMessage.text = text
	$CountdownMessage.show()
	$CountdownMessageTimer.start()

func show_game_over() -> void:
	show_message("Game Over")
	# Wait until the CountdownMessageTimer has counted down.
	await $CountdownMessageTimer.timeout

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
	$CountdownMessage.hide()

func hide_start_button() -> void:
	$StartButton.hide()

func _on_start_button_pressed() -> void:
	start_game.emit()
	show_game_start()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
