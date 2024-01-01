extends Node

@export var grid_size: Vector2 = Vector2(8,8)

var track := ResourceLoader.load("res://Scenes/Buildings/Railroads/track.tscn")

var _current_spawnable: Track
var _preview_container: Node2D
var _container: Node2D
var _clicks: int  = 0
var _connecting_track: Track
var _connecting_side: int

func _ready() -> void:
	_preview_container = Node2D.new()
	_preview_container.name = "TrackPreviewContainer"
	get_tree().root.add_child.call_deferred(_preview_container)
	_container = get_tree().get_first_node_in_group("track_building_container")


func _process(_delta: float) -> void:
	if GameManager._current_state == GameManager.State.TRACK_BUILD:
		var camera: Camera2D = get_viewport().get_camera_2d()
		var mouse_pos: Vector2 = camera.get_global_mouse_position()
		var cursor_pos: Vector2 = mouse_pos.snapped(grid_size)
		if _connecting_track:
			_handle_connecting_track()
		else:
			_handle_building_pos(cursor_pos)


func _handle_building_pos(pos: Vector2) -> void:
	if _clicks == 0:
		_current_spawnable.position = pos
	elif _clicks == 1:
		_current_spawnable.curve.set_point_position(
			1,
			pos - _current_spawnable.position
		)


func _handle_connecting_track() -> void:
	var connecting_point = _connecting_track.curve.get_point_position(_connecting_side)
	var cnn_pos = connecting_point + _connecting_track.position
	if _clicks == 0:
		_current_spawnable.position = cnn_pos
	else:
		_current_spawnable.curve.set_point_position(
			1,
			cnn_pos - _current_spawnable.position
		)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		_cancel_build_mode()
	if Input.is_action_just_released("mouse_left"):
		_place_track_point(_clicks)


func _place_track_point(click: int) -> void:
	if GameManager._current_state != GameManager.State.TRACK_BUILD:
		return
		
	_clicks += 1
	if click == 1:
		var obj := _current_spawnable.duplicate()
		obj.modulate = Color(1,1,1,1)
		_container.add_child(obj)
		spawn_track()
		obj.enable_junctions()


func _cancel_build_mode() -> void:
	if GameManager._current_state != GameManager.State.TRACK_BUILD:
		return
	
	if _clicks > 0:
		_clicks -= 1
		_current_spawnable.curve.set_point_position(1, Vector2(32,0))
	else:
		GameManager._current_state = GameManager.State.SIMULATION
		_current_spawnable.queue_free()
		_current_spawnable = null


func spawn_track() -> void:
	_spawn_object(track)
	_clicks = 0

func _spawn_object(obj: PackedScene) -> void:
	if _current_spawnable:
		_current_spawnable.queue_free()
	_current_spawnable = obj.instantiate()
	_current_spawnable.modulate = Color(1,1,1,0.45)
	_preview_container.add_child(_current_spawnable)
	GameManager._current_state = GameManager.State.TRACK_BUILD

