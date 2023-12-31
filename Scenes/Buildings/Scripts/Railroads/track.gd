@tool
class_name Track
extends Path2D

@export var crosstie_distance: float = 8:
	set(value):
		crosstie_distance = value
		_update_crossties()

func _ready() -> void:
	curve.changed.connect(_update_sprites)


func enable_junctions() -> void:
	%HeadOut.connect_signals()
	%HeadIn.connect_signals()
	%TailOut.connect_signals()
	%TailIn.connect_signals()


func disable_junctions() -> void:
	%HeadOut.disconnect_signals()
	%HeadIn.disconnect_signals()
	%TailOut.disconnect_signals()
	%TailIn.disconnect_signals()


func _update_sprites() -> void:
	$Line2D.points = curve.get_baked_points()
	$Head.progress_ratio = 0
	$Tail.progress_ratio = 1
	_update_crossties()


func _update_crossties() -> void:
	var crossties: MultiMesh = $Crossties.multimesh
	crossties.mesh = $Crosstie.mesh
	
	var curve_len = curve.get_baked_length()
	var crosstie_count = round(curve_len / crosstie_distance)
	crossties.instance_count = crosstie_count
	
	for i in range(crosstie_count):
		var t = Transform2D()
		var crosstie_position = curve.sample_baked((i * crosstie_distance) + crosstie_distance/2)
		var next_position = curve.sample_baked((i + 1) * crosstie_distance)
		t = t.rotated((next_position - crosstie_position).normalized().angle())
		t.origin = crosstie_position
		crossties.set_instance_transform_2d(i, t)
	
