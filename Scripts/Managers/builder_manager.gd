extends Node
class_name BuildManager

signal demolish_toggled(toggled: bool)

const grid_size: Vector2i = Vector2i(8,8)
const demolish_helper: PackedScene = preload("res://UI/Builder/mouse_collision.tscn")

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
var _cursor_collision: CursorCollision

#region Virtual Functions
func _ready() -> void:
	_building_container = get_tree().get_first_node_in_group("building_container")
	_create_preview_container()
	_get_builder_ui()
	_create_cursor_collison()


func _process(_delta: float) -> void:
	_update_preview(_get_mouse_pos())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_destroy_building"):
		_place_building_in_world()
		_demolish_buidling_in_world()
#endregion


#region Build/Destroy/Select
func _place_building_in_world() -> void:
	if _current_state != State.BUILD:
		return
	if !_current_preview or !_current_preview._is_placeable:
		return
	
	var placeable: Building = _current_preview.duplicate()
	placeable._is_preview = false
	placeable._reset_shader_material()
	
	_current_preview._is_preview = true
	
	if placeable.collided.is_connected(_handle_preview_collision):
		placeable.collided.disconnect(_handle_preview_collision)
	_building_container.add_child(placeable)
	
	if !Input.is_action_pressed("shift"):
		_exit_build_mode()


func _demolish_buidling_in_world() -> void:
	if _current_state != State.DESTROY:
		return
	
	if _cursor_collision._current_selected:
		_cursor_collision._current_selected._demolish_self()


func _select_building(build: Building) -> void:
	build._update_select_box_visiblility(true)
	pass


func _deselect_building(build: Building) -> void:
	build._update_select_box_visiblility(false)
	pass
#endregion


#region BuilderManagement State Machine
func _enter_build_mode(obj: Building) -> void:
	if _current_state == State.DESTROY:
		_toggle_demolish_mode(State.BUILD)
	else:
		_current_state = State.BUILD
	_clear_preview()
	_current_preview = obj
	_current_preview.collided.connect(_handle_preview_collision)
	_current_preview._is_preview = true
	_preview_container.add_child(_current_preview)


func _exit_build_mode() -> void:
	_current_state = State.NONE
	demolish_toggled.emit(_current_state == State.DESTROY)
	_clear_preview()


func _toggle_demolish_mode(state_to: State = State.NONE) -> void:
	if _current_state == State.DESTROY:
		_current_state = state_to
	else:
		_current_state = State.DESTROY
	demolish_toggled.emit(_current_state == State.DESTROY)
#endregion


#region Process Calls
func _handle_preview_collision(is_colliding: bool) -> void:
	_current_preview._is_placeable = !is_colliding


func _update_preview(mouse_pos: Vector2i) -> void:
	if _current_state == State.BUILD:
		_current_preview.position = mouse_pos.snapped(grid_size)
	
	if Input.is_action_just_pressed("exit_build_mode"):
		_exit_build_mode()
#endregion


#region Helper Functions
func _get_builder_ui() ->void:
	_builder_ui = get_tree().get_first_node_in_group("builder_ui")
	_builder_ui.buidling_selected.connect(_enter_build_mode)
	_builder_ui.demolish_mode_toggled.connect(_toggle_demolish_mode)
	demolish_toggled.connect(_builder_ui._update_demolish_overlay)


func _get_mouse_pos() -> Vector2:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var mouse_pos: Vector2 = camera.get_global_mouse_position()
	return mouse_pos


func _clear_preview() -> void:
	if !_current_preview:
		return
	if _current_preview.collided.is_connected(_handle_preview_collision):
		_current_preview.collided.disconnect(_handle_preview_collision)
	_current_preview.queue_free()
	_current_preview = null


func _create_cursor_collison() -> void:
	_cursor_collision = demolish_helper.instantiate()
	_cursor_collision.z_index += 1
	add_child.call_deferred(_cursor_collision)
	_cursor_collision.building_selected.connect(_select_building)
	_cursor_collision.building_deselected.connect(_deselect_building)


func _create_preview_container() -> void:
	_preview_container = Node2D.new()
	_preview_container.name = "BuildPreview"
	_preview_container.z_index += 1
	add_child.call_deferred(_preview_container)
#endregion











