extends Control
class_name BuilderUI

@onready var button_container: HBoxContainer = %ButtonContainer

signal buidling_selected(building: Building)
signal demolish_mode_toggled()

@export var building_list: Array[BuildingData]

func _ready() -> void:
	#TranslationServer.set_locale("en")
	_populate_buttons()
	


func _populate_buttons() -> void:
	if !building_list:
		return
	for i in range(building_list.size()):
		var button: Button = Button.new()
		_set_up_building_button(button, building_list[i])


func _set_up_building_button(button: Button, build_data: BuildingData) -> void:
	button_container.add_child.call_deferred(button)
	button.name = tr(build_data.building_name_id)
	button.icon = build_data.building_button_icon
	button.tooltip_text = tr(build_data.building_name_id)
	button.custom_minimum_size = Vector2(40,40)
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(build_data._select_this_building)
	build_data.building_selected.connect(_select_building)


func _select_building(obj: Building) -> void:
	buidling_selected.emit(obj)


func _update_demolish_overlay(toggled: bool) -> void:
	%BulldozerOverlay.visible = toggled


func _on_demolish_pressed() -> void:
	demolish_mode_toggled.emit()

