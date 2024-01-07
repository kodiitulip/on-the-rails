extends Node2D
class_name Building

signal collided(is_colliding: bool)

const placeable_shader: VisualShader = preload("res://UI/Builder/Shaders/placeable_shader.tres")
const outline_shader: VisualShader = preload("res://UI/Builder/Shaders/outline_shader.tres")

enum Orientation {
	N,
	S,
	W,
	E,
}


var objects: Array[Area2D]
var material_backup: Material

var _is_preview: bool = false:
	set = _update_shader_is_preview
var _is_placeable: bool = true:
	set = _update_shader_is_placeable

func _ready() -> void:
	material_backup = material
	$Collision.area_entered.connect(_on_collision_area_entered)
	$Collision.area_exited.connect(_on_collision_area_exited)


func _update_shader_is_preview(value: bool) -> void:
	_is_preview = value
	material = ShaderMaterial.new()
	material.shader = placeable_shader


func _update_shader_is_placeable(value: bool) -> void:
	_is_placeable = value
	material.set_shader_parameter("IsPlaceable", value)


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


func _reset_shader_material() -> void:
	material = material_backup
