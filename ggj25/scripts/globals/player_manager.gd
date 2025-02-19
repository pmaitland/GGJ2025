extends Node

const SUPPORTED_PLAYERS = 4
const HOLD_TIME = 1

var joined_devices: Array = Utils.create_array(SUPPORTED_PLAYERS, false)
var team_assignments: Array = Utils.create_array(SUPPORTED_PLAYERS, -1)
var button_held_time: Array = Utils.create_array(SUPPORTED_PLAYERS, 0.0)
var _joining_enabled := true

signal player_joined
signal player_left


func _ready() -> void:
	joined_devices[0] = true  # Player 1 starts joined
	
	# Default connected controllers to joined until we have UI
	for device_id in range(SUPPORTED_PLAYERS):
		if is_controller_connected(device_id):
			_join(device_id)


func _process(delta: float) -> void:
	if !_joining_enabled: return  # Can't join during games etc.
	
	for device_id in range(SUPPORTED_PLAYERS):
		if is_joined(device_id):
			_handle_joined_device(device_id, delta)
		else:
			_handle_unjoined_device(device_id, delta)


func _handle_joined_device(device_id: int, delta: float) -> void:
	_track_held_time(device_id, "p%s_leave" % device_id, delta)
	
	if button_held_time[device_id] >= HOLD_TIME:
		_unjoin(device_id)
		


func _handle_unjoined_device(device_id: int, delta: float) -> void:
	_track_held_time(device_id, "p%s_join" % device_id, delta)
	
	if button_held_time[device_id] >= HOLD_TIME:
		_join(device_id)


func _track_held_time(device_id, action: StringName, delta: float) -> void:
	if Input.is_action_pressed(action):
		button_held_time[device_id] += delta
	else:
		button_held_time[device_id] = 0


## Returns a list of joined player_ids
func get_joined_players() -> Array[int]:
	var result = []
	for i in range(joined_devices.size()):
		if is_joined(i):
			result.append(i)
	return result


func _join(device_id: int) -> void:
	print("%s joined!" % get_player_name(device_id))
	player_joined.emit(device_id)
	joined_devices[device_id] = true
	button_held_time[device_id] = 0


func _unjoin(device_id: int) -> void:
	print("%s left!" % get_player_name(device_id))
	player_left.emit(device_id)
	joined_devices[device_id] = false
	button_held_time[device_id] = 0


## Is the player_id connected AND joined
func is_joined(player_id: int) -> bool:
	return joined_devices[player_id]


func is_controller_connected(device_id: int) -> bool:
	return device_id < 2 or Input.get_connected_joypads().has(device_id)


## Progress of join/unjoin button being held (0-1)
func get_button_held_percentage(device_id: int) -> float:
	return button_held_time[device_id] / HOLD_TIME


func set_joining_enabled(value: bool) -> void:
	_joining_enabled = value


func get_player_name(player_id: int) -> String:
	return "Player %s" % (player_id + 1)
