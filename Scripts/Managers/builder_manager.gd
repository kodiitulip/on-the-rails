extends Node
class_name BuildManagerStateMachine

@export var build_state: StateBuild
@export var destroy_state: StateDestroy
@export var track_state: StateTrack
@export var none_state: BuildingState

var current_state: BuildingState
var states: Dictionary = {}
var builder_ui: BuilderUI

func _ready() -> void:
	current_state = none_state
	get_builder_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_build_mode"):
		_transition_to_none()


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _transition_to_build(build: Building) -> void:
	if !build:
		push_error("the building is not valid")
		return
	if current_state != build_state:
		current_state.exit()
		current_state = build_state
	current_state.enter_build(build)


func _transition_to_destroy() -> void:
	if current_state != destroy_state:
		current_state.exit()
		current_state = destroy_state
	
	current_state.enter()


func _transition_to_none() -> void:
	if current_state != none_state:
		current_state.exit()
		current_state = none_state
	
	current_state.enter()


func _transition_to_track() -> void:
	if current_state != track_state:
		current_state.exit()
		current_state = track_state
	
	current_state.enter()


func _toggle_destroy() -> void:
	if current_state != destroy_state:
		_transition_to_destroy()
	else:
		_transition_to_none()


func get_builder_ui() -> void:
	builder_ui = get_tree().get_first_node_in_group("builder_ui")
	builder_ui.buidling_selected.connect(_transition_to_build)
	builder_ui.demolish_mode_toggled.connect(_toggle_destroy)


func select_building(build: Building) -> void:
	build._update_select_box_visiblility(true)


func deselect_building(build: Building) -> void:
	build._update_select_box_visiblility(false)
