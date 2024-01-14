extends BuildingState
class_name StateDestroy

@export var cursor_collision: CursorCollision


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_destroy_building"):
		_demolish_buidling_in_world()


func enter() -> void:
	set_process_unhandled_input(true)
	if !cursor_collision:
		push_error("no cursor collision found")
		return
	cursor_collision._toggle_demolish(true)


func exit() -> void:
	set_process_unhandled_input(false)
	if !cursor_collision:
		push_error("no cursor collision found")
		return
	cursor_collision._toggle_demolish(false)


func _demolish_buidling_in_world() -> void:
	if !cursor_collision:
		return
	if cursor_collision._current_selected:
		cursor_collision._current_selected._demolish_self()
