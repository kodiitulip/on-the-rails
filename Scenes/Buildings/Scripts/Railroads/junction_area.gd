class_name JunctionArea
extends Area2D

@onready var track: Track = $"../.." as Track
@onready var sprite: Sprite2D = $Arrow

@export_enum("Head:0", "Tail:1") var track_side: int
@export_enum("Out:0", "In:1") var track_part: int


func connect_signals() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func disconnect_signals() -> void:
	area_entered.disconnect(_on_area_entered)
	area_exited.disconnect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	sprite.visible = true
	TrackBuildManager._connecting_track = track
	TrackBuildManager._connecting_side = track_side


func _on_area_exited(area: Area2D) -> void:
	sprite.visible = false
	TrackBuildManager._connecting_track = null
