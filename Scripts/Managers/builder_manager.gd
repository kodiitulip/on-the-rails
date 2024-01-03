extends Node
class_name BuildManager

signal demolish_toggled(toggled: bool)

const grid_size: Vector2i = Vector2i(8,8)

enum State {
	NONE,
	BUILD,
	DESTROY,
}

var _current_state: State = State.NONE:
	set(value):
		_current_state = value
		set_process(value != State.NONE)
var _preview_container: Node2D
var _builder_ui: BuilderUI
var _current_preview: Building
var _building_container: Node2D

func _ready() -> void:
	_building_container = get_tree().get_first_node_in_group("building_container")
	_create_preview_container()
	_get_builder_ui()


func _process(_delta: float) -> void:
	_update_preview(_get_cursor_pos())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_building"):
		_place_building_in_world()


func _place_building_in_world() -> void:
	if !_current_preview or \
			!_current_state == State.BUILD or \
			!_current_preview._is_placeable:
		return
	
	var placeable: Building = _current_preview.duplicate()
	#_current_preview._is_placeable = false
	placeable._is_preview = false
	if placeable.collided.is_connected(_handle_preview_collision):
		placeable.collided.disconnect(_handle_preview_collision)
	_building_container.add_child(placeable)
	if !Input.is_action_pressed("shift"):
		_exit_build_mode()


func _get_cursor_pos() -> Vector2i:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var mouse_pos: Vector2 = camera.get_global_mouse_position()
	var cursor_pos: Vector2i = mouse_pos.snapped(grid_size)
	return cursor_pos


func _update_preview(cursor_pos: Vector2i) -> void:
	if _current_state == State.BUILD:
		_current_preview.position = cursor_pos
	
	if Input.is_action_just_pressed("exit_build_mode"):
		_exit_build_mode()


func _get_builder_ui() ->void:
	_builder_ui = get_tree().get_first_node_in_group("builder_ui")
	_builder_ui.buidling_selected.connect(_enter_build_mode)
	_builder_ui.demolish_mode_toggled.connect(_toggle_demolish_mode)
	demolish_toggled.connect(_builder_ui._update_demolish_overlay)


func _enter_build_mode(obj: Building) -> void:
	_current_state = State.BUILD
	_clear_preview()
	_current_preview = obj
	_current_preview.collided.connect(_handle_preview_collision)
	_current_preview._is_preview = true
	_preview_container.add_child(_current_preview)


func _handle_preview_collision(is_colliding: bool) -> void:
	_current_preview._is_placeable = !is_colliding


func _toggle_demolish_mode() -> void:
	if _current_state == State.DESTROY:
		_current_state = State.NONE
	else:
		_current_state = State.DESTROY
	demolish_toggled.emit(_current_state == State.DESTROY)


func _clear_preview() -> void:
	if !_current_preview:
		return
	if _current_preview.collided.is_connected(_handle_preview_collision):
		_current_preview.collided.disconnect(_handle_preview_collision)
	_current_preview.queue_free()
	_current_preview = null


func _exit_build_mode() -> void:
	_current_state = State.NONE
	demolish_toggled.emit(_current_state == State.DESTROY)
	_clear_preview()


func _create_preview_container() -> void:
	_preview_container = Node2D.new()
	_preview_container.name = "BuildPreview"
	add_child.call_deferred(_preview_container)
