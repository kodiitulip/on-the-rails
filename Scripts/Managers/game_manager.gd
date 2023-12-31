extends Node

enum State {
	PAUSED = -1,
	SIMULATION = 0,
	BUILD = 1,
	TRACK_BUILD = 2,
}

var _current_state: State = State.SIMULATION

func _ready() -> void:
	print(_current_state)
