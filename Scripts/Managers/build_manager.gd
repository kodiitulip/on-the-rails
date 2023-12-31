extends Node

@export var grid_size: Vector2 = Vector2(8,8)

#region Buildables
var building := ResourceLoader.load("res://Scenes/Buildings/building.tscn")
var train_depot := ResourceLoader.load("res://Scenes/Buildings/Railroads/Buildings/train_depot.tscn")
#endregion

var _current_spawnable: SpawnableBuilding
var _preview_container: Node2D
var _container: Node2D

func _ready() -> void:
	_preview_container = Node2D.new()
	_preview_container.name = "PreviewContainer"
	get_tree().root.add_child.call_deferred(_preview_container)
	_container = get_tree().get_first_node_in_group("building_container")


func _process(_delta: float) -> void:
	if GameManager._current_state == GameManager.State.BUILD:
		var camera: Camera2D = get_viewport().get_camera_2d()
		var mouse_pos: Vector2 = camera.get_global_mouse_position()
		var cursor_pos: Vector2 = mouse_pos.snapped(grid_size)
		_current_spawnable.position = cursor_pos


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		_cancel_build_mode()
	if Input.is_action_just_released("mouse_left"):
		_place_objects_in_world()


func _place_objects_in_world() -> void:
	if GameManager._current_state == GameManager.State.BUILD:
		var obj := _current_spawnable.duplicate()
		obj.modulate = Color(1,1,1,1)
		_container.add_child(obj)


func _cancel_build_mode() -> void:
	if GameManager._current_state == GameManager.State.BUILD:
		GameManager._current_state = GameManager.State.SIMULATION
		_current_spawnable.queue_free()
		_current_spawnable = null


func spawn_gen_building() -> void:
	_spawn_object(building)


func spawn_train_depot() -> void:
	_spawn_object(train_depot)

func _spawn_object(obj: PackedScene) -> void:
	if _current_spawnable:
		_current_spawnable.queue_free()
	_current_spawnable = obj.instantiate()
	_current_spawnable.modulate = Color(1,1,1,0.45)
	_preview_container.add_child(_current_spawnable)
	GameManager._current_state = GameManager.State.BUILD

