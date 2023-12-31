class_name PanningCamera
extends Camera2D

@export var can_pan: bool = true
@export var can_zoom: bool = true
@export var speed_pan_speed: float = 1.0

@export_group("Zoom", "zoom_")
@export var zoom_min: float = 0.2
@export var zoom_max: float = 2.5
@export var zoom_factor: float = 0.1
@export var zoom_duration: float = 0.2


var _target_zoom: float = 1.0:
	set = _set_zoom_level


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: 
		_handle_drag(event)
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_wheel_up"):
			_target_zoom += zoom_factor
		if event.is_action_pressed("mouse_wheel_down"):
			_target_zoom -= zoom_factor

func _handle_drag(event: InputEventMouseMotion) -> void:
	if Input.is_action_pressed("mouse_middle") and can_pan:
		offset -= event.relative * speed_pan_speed / zoom.x


func _set_zoom_level(value: float) -> void:
	_target_zoom = clamp(value, zoom_min, zoom_max)
	var t := create_tween()
	t.tween_property(
		self,
		"zoom",
		Vector2(_target_zoom, _target_zoom),
		zoom_duration
	).from(zoom).set_ease(Tween.EASE_OUT)
