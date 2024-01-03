extends Node2D
class_name Building

signal collided(is_colliding: bool)

enum Orientation {
	N,
	S,
	W,
	E,
}

var objects: Array[Area2D]

var _is_preview: bool = false
var _is_placeable: bool = true

func _ready() -> void:
	$Collision.area_entered.connect(_on_collision_area_entered)
	$Collision.area_exited.connect(_on_collision_area_exited)
	print(_is_placeable)


func _on_collision_area_entered(area) -> void:
	if !_is_preview:
		return
	objects.append(area)
	collided.emit(true)


func _on_collision_area_exited(area) -> void:
	if !_is_preview:
		return
	objects.remove_at(objects.find(area))
	if objects.size() <= 0:
		collided.emit(false)

