class_name InputValueComponent

extends Node

@export var input: String

signal on_pressed
signal on_released

var value: bool

func _input(_event: InputEvent) -> void:
	var new_value = Input.is_action_pressed(input)
	if (new_value == value):
		return
	value = new_value
	if (value):
		on_pressed.emit()
	else :
		on_released.emit()
	
