extends Control
class_name BuilderUI

@onready var button_container: HBoxContainer = %ButtonContainer

signal buidling_selected(building: Building)
signal demolish_mode_toggled()

@export var building_list: Array[BuildingData]

func _ready() -> void:
	_populate_buttons()


func _populate_buttons() -> void:
	if !building_list:
		return
	for i in range(building_list.size()):
		var button: Button = Button.new()
		button.name = building_list[i].building_name
		button.icon = building_list[i].building_button_icon
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size = Vector2(40,40)
		button.tooltip_text = building_list[i].building_name
		button_container.add_child.call_deferred(button)
		button.pressed.connect(building_list[i]._select_this_building)
		building_list[i].building_selected.connect(_select_building)


func _select_building(obj: Building) -> void:
	buidling_selected.emit(obj)


func _update_demolish_overlay(toggled: bool) -> void:
	$BulldozerUIOverlay.visible = toggled
	%BulldozerOverlay.visible = toggled


func _on_demolish_pressed() -> void:
	demolish_mode_toggled.emit()

