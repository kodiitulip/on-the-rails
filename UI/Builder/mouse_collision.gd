extends Area2D
class_name CursorCollision

signal building_selected(building: Building)
signal building_deselected(building: Building)

var _objects: Array[Building]
var _current_selected: Building

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	position = get_global_mouse_position()


func _on_area_entered(area: Building) -> void:
	if area._is_preview:
		return
	_objects.append(area)
	_current_selected = _objects[_objects.size() - 1]
	building_selected.emit(_current_selected)


func _on_area_exited(area: Building) -> void:
	if area._is_preview:
		return
	_objects.remove_at(_objects.find(area))
	if _current_selected:
		_current_selected = null
	building_deselected.emit(area)
