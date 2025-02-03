extends Control

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/GridContainer/MasterSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/GridContainer/MusicSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/GridContainer/SFXSlider

@onready var master_bus_index: int = AudioServer.get_bus_index("Master")
@onready var music_bus_index: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index: int = AudioServer.get_bus_index("SFX")


func _ready() -> void:
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))
	master_slider.grab_focus()

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))


func _on_back_button_pressed() -> void:
	SceneManager.go_back()
