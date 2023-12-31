extends Node

@export var grid_size: Vector2 = Vector2(8,8)

var track := ResourceLoader.load("res://Scenes/Buildings/Railroads/track.tscn")

var _current_spawnable: Track
var _preview_container: Node2D
var _container: Node2D
var _clicks: int  = 0

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
		if _clicks == 0:
			_current_spawnable.position = cursor_pos
		elif _clicks == 1:
			_current_spawnable.curve.set_point_position(
				1,
				(mouse_pos - _current_spawnable.position).snapped(grid_size)
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

