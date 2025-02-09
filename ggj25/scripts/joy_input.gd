extends Node


var _physics_inputs: Dictionary
var _prev_physics_inputs: Dictionary
var _process_inputs: Dictionary
var _prev_process_inputs: Dictionary


# Add buttons we care about here
const TEMPLATE_INPUTS = {
	JOY_BUTTON_A: false,
	JOY_BUTTON_B: false,
}

enum Caller {
	PROCESS,
	PHYSICS_PROCESS,
}

func is_joy_button_just_pressed(device_id: int, button: JoyButton, caller: Caller) -> bool:
	if caller == Caller.PROCESS:
		return _is_button_just_pressed(_process_inputs, _prev_process_inputs, device_id, button)
	elif caller == Caller.PHYSICS_PROCESS:
		return _is_button_just_pressed(_physics_inputs, _prev_physics_inputs, device_id, button)
	assert(false, "Invalid caller to is_joy_button_just_pressed")
	return false


func _is_button_just_pressed(inputs: Dictionary, prev_inputs: Dictionary, device_id: int, button: JoyButton) -> bool:
	if button not in TEMPLATE_INPUTS:
		push_error("button: %s is not tracked, update TEMPLATE_INPUTS in joy_input.gd" % button)
		return false
	
	if device_id not in inputs:
		push_warning("Device: %s not known" % device_id)
		return false
	
	return inputs[device_id][button] and not (device_id in prev_inputs and prev_inputs[device_id][button])


func _ready() -> void:
	for device_id in Input.get_connected_joypads():
		print("Connected Joypad: %s" % Input.get_joy_name(device_id))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_prev_process_inputs = _copy(_process_inputs)
	_detect_inputs(_process_inputs)


func _physics_process(delta: float) -> void:
	_prev_physics_inputs = _copy(_physics_inputs)
	_detect_inputs(_physics_inputs)


func _detect_inputs(map: Dictionary) -> void:
	for device_id in Input.get_connected_joypads():
		if device_id not in map:
			map[device_id] = TEMPLATE_INPUTS.duplicate(true)
		
		for button in map[device_id]:
			map[device_id][button] = Input.is_joy_button_pressed(device_id, button)


func _copy(map: Dictionary) -> Dictionary:
	var copy = {}
	for id in map:
		copy[id] = map[id].duplicate()
	return copy
