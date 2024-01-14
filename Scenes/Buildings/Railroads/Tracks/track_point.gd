extends Building
class_name TrackPoint

var other_point: TrackPoint

func _demolish_self() -> void:
	if other_point:
		other_point.queue_free()
		other_point = null
	queue_free()


func _update_select_box_visiblility(toggled: bool) -> void:
	$SelectBox.visible = toggled
	if other_point:
		other_point.get_node("SelectBox").visible = toggled
