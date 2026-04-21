class_name InputVectorComponent

extends Node

@export var left_input_name : String
@export var right_input_name : String
@export var up_input_name : String
@export var down_input_name : String

signal on_value_changed(value: Vector2)

var value : Vector2 = Vector2.ZERO

func _input(_event: InputEvent) -> void:
	update_value()
	
func update_value():
	var new_value = Input.get_vector(left_input_name,right_input_name, up_input_name, down_input_name)
	if (value != new_value):
		value = new_value
		on_value_changed.emit(value)
