extends BuildingState
class_name StateBuild

const build_cursor = preload("res://Assets/UI/Cursors/wrench.png")

@export var grid_size: Vector2i = Vector2i(8,8)
@export var build_preview: Node2D

var building_container: Node2D
var builder_ui: BuilderUI
var current_build: Building

func _ready() -> void:
	set_process_unhandled_input(false)
	building_container = get_tree().get_first_node_in_group("building_container")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_destroy_building"):
		place_building_in_world()
	
	if event.is_action_pressed("rotate_building_clockward"):
		current_build._rotate_building(1)
	elif event.is_action_pressed("rotate_building_counterclockward"):
		current_build._rotate_building(-1)
	elif event.is_action_pressed("flip_horizontal"):
		current_build._flip_building(Building.Flip.HORIZONTAL)
	elif event.is_action_pressed("flip_vertical"):
		current_build._flip_building(Building.Flip.VERTICAL)


func enter_build(build: Building) -> void:
	set_process_unhandled_input(true)
	Input.set_custom_mouse_cursor(build_cursor)
	clear_preview()
	current_build = build
	current_build.collided.connect(handle_preview_collision)
	current_build._is_preview = true
	build_preview.add_child(current_build)


func exit() -> void:
	set_process_unhandled_input(false)
	Input.set_custom_mouse_cursor(null)
	clear_preview()


func update(_delta: float) -> void:
	if current_build:
		current_build.position = get_mouse_pos().snapped(grid_size)


func place_building_in_world() -> void:
	if !current_build or !current_build._is_placeable:
		return
	
	var placeable: Building = current_build.duplicate()
	placeable.build_self(building_container)
	


func handle_preview_collision(is_colliding: bool) -> void:
	current_build._is_placeable = !is_colliding


func clear_preview() -> void:
	if !current_build:
		return
	if current_build.collided.is_connected(handle_preview_collision):
		current_build.collided.disconnect(handle_preview_collision)
	current_build.queue_free()
	current_build = null


func get_mouse_pos() -> Vector2:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var mouse_pos: Vector2 = camera.get_global_mouse_position()
	return mouse_pos
