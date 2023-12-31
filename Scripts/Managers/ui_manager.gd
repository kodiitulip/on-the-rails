extends Control



func _on_build_building_pressed() -> void:
	BuildManager.spawn_train_depot()


func _on_build_track_pressed() -> void:
	TrackBuildManager.spawn_track()
	pass
