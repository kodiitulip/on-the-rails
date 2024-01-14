extends Node
class_name BuildingState


func _ready() -> void:
	set_process_unhandled_input(false)


func enter() -> void:
	set_process_unhandled_input(true)


func exit() -> void:
	set_process_unhandled_input(false)


func update(_delta: float) -> void:
	pass
