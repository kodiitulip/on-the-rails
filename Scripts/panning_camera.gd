extends Camera2D
class_name PanningCamera

## The speed the camera moves
@export var pan_speed: float = 1.0
#region Camera Flags
@export_group("Camera Flags", "camera_")
## If [code]true[/code] the camera can pan
@export var camera_can_pan: bool = true
## If [code]true[/code] the camera can zoom
@export var camera_can_zoom: bool = true
#endregion

#region Zoom
@export_group("Zoom", "zoom_")
## The min of zoom out
@export var zoom_min: float = 0.2
## The max of zoom in
@export var zoom_max: float = 2.5
## The amount of zoom for each press
@export var zoom_factor: float = 0.1
## The duration of zoom easing
@export var zoom_duration: float = 0.2
#endregion

var _target_zoom: float = 1.0:
	set = _set_zoom_level


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_pan(event)
	if event is InputEventMouseButton:
		if event.is_action_pressed("camera_zoom_in"):
			_target_zoom += zoom_factor
		elif event.is_action_pressed("camera_zoom_out"):
			_target_zoom -= zoom_factor


func _handle_pan(event: InputEventMouseMotion) -> void:
	if Input.is_action_pressed("camera_pan"):
		offset -= event.relative * pan_speed / zoom.x


func _set_zoom_level(value: float) -> void:
	_target_zoom = clamp(value, zoom_min, zoom_max)
	var t: Tween = create_tween()
	t.tween_property(
		self,
		"zoom",
		Vector2(_target_zoom,_target_zoom),
		zoom_duration
	).from(zoom)
