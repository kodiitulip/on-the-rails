extends Area2D
class_name Building

signal collided(is_colliding: bool)

const placeable_shader: VisualShader = preload("res://UI/Builder/Shaders/placeable_shader.tres")

enum Flip {
	HORIZONTAL,
	VERTICAL,
}

@export_enum("North:3", "West:2", "South:1", "East:0") var orientation: int = 0:
	set(value):
		orientation = wrapi(value, 0, 4)
		rotation_degrees = 90 * orientation
@export var is_duplicable: bool = true

var objects: Array[Building]
var material_backup: Material

var _is_preview: bool = false:
	set = _update_shader_is_preview
var _is_placeable: bool = true:
	set = _update_shader_is_placeable

func _ready() -> void:
	material_backup = material
	area_entered.connect(_on_collision_area_entered)
	area_exited.connect(_on_collision_area_exited)


func _rotate_building(ori: int) -> void:
	orientation += ori


func _flip_building(ori: Flip) -> void:
	if ori == Flip.HORIZONTAL:
		scale.x *= -1
	elif ori == Flip.VERTICAL:
		scale.y *= -1


func _update_select_box_visiblility(toggled: bool) -> void:
	$SelectBox.visible = toggled


func _update_shader_is_preview(value: bool) -> void:
	_is_preview = value
	material = ShaderMaterial.new()
	material.shader = placeable_shader


func _update_shader_is_placeable(value: bool) -> void:
	_is_placeable = value
	material.set_shader_parameter("IsPlaceable", value)


func build_self(container: Node2D) -> void:
	_is_preview = false
	_reset_shader_material()
	
	for conn in collided.get_connections():
		collided.disconnect(conn["callable"])
	container.add_child(self)


func _demolish_self() -> void:
	queue_free()


func _on_collision_area_entered(area) -> void:
	if _is_preview and area is Building:
		objects.append(area)
		collided.emit(true)


func _on_collision_area_exited(area) -> void:
	if _is_preview and area is Building:
		objects.remove_at(objects.find(area))
		if objects.size() <= 0:
			collided.emit(false)


func _reset_shader_material() -> void:
	material = material_backup
