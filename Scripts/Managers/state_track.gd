extends BuildingState
class_name StateTrack

const build_cursor = preload("res://Assets/UI/Cursors/wrench.png")
const track_point = preload("res://Scenes/Buildings/Railroads/Tracks/track_point.tscn")

@export var grid_size: Vector2i = Vector2i(8,8)
@export var build_preview: Node2D

var building_container: Node2D
var builder_ui: BuilderUI
var current_build: Building

var track_start: TrackPoint
var track_end: TrackPoint

func _ready() -> void:
	set_process_unhandled_input(false)
	building_container = get_tree().get_first_node_in_group("building_container")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_destroy_building"):
		if !track_start:
			place_track_start()
		else:
			place_track_end()
	
	if event.is_action_pressed("rotate_building_clockward"):
		current_build._rotate_building(1)
	elif event.is_action_pressed("rotate_building_counterclockward"):
		current_build._rotate_building(-1)


func enter() -> void:
	set_process_unhandled_input(true)
	Input.set_custom_mouse_cursor(build_cursor)
	clear_preview()
	current_build = track_point.instantiate()
	current_build.collided.connect(handle_preview_collision)
	current_build._is_preview = true
	build_preview.add_child(current_build)


func place_track_start() -> void:
	if !current_build or !current_build._is_placeable:
		return
	var place: Building = current_build.duplicate()
	place.build_self(building_container)
	track_start = place
	enter()


func place_track_end() -> void:
	if !current_build or !current_build._is_placeable:
		return
	var place: Building = current_build.duplicate()
	place.build_self(building_container)
	track_end = place
	track_end.other_point = track_start
	track_start.other_point = track_end
	exit()


func exit() -> void:
	set_process_unhandled_input(false)
	track_end = null
	track_start = null
	Input.set_custom_mouse_cursor(null)
	clear_preview()


func clear_preview() -> void:
	if !current_build:
		return
	if current_build.collided.is_connected(handle_preview_collision):
		current_build.collided.disconnect(handle_preview_collision)
	current_build.queue_free()
	current_build = null


func update(_delta: float) -> void:
	if current_build:
		current_build.position = get_mouse_pos().snapped(grid_size)


func get_mouse_pos() -> Vector2:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var mouse_pos: Vector2 = camera.get_global_mouse_position()
	return mouse_pos


func handle_preview_collision(is_colliding: bool) -> void:
	current_build._is_placeable = !is_colliding


