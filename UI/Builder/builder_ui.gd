extends Control
class_name BuilderUI

@onready var button_container: HBoxContainer = %ButtonContainer

signal buidling_selected(building: BaseBuilding)
signal demolish_mode_toggled()

@export var building_list: Array[BuildingData]

func _ready() -> void:
	_populate_buttons()


func _populate_buttons() -> void:
	if !building_list:
		return
	for i in range(building_list.size()):
		var b: Button = Button.new()
		b.name = building_list[i].building_name
		b.icon = building_list[i].building_button_icon
		b.expand_icon = true
		b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(40,40)
		button_container.add_child.call_deferred(b)
		b.pressed.connect(building_list[i]._select_this_building)
		building_list[i].building_selected.connect(_select_building)


func _select_building(obj: BaseBuilding) -> void:
	buidling_selected.emit(obj)


func _on_demolish_pressed() -> void:
	demolish_mode_toggled.emit()
