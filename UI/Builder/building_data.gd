extends Resource
class_name BuildingData

signal building_selected(obj: Building)

@export var building_name: String
@export var building_button_icon: Texture2D
@export var building_scene: PackedScene


func _select_this_building() -> void:
	building_selected.emit(building_scene.instantiate())
