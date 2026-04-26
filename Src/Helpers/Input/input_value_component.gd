class_name InputValueComponent

extends Node

@export var input: String

signal on_pressed
signal on_released

var pressed: ObservableBool

func _ready() -> void:
	pressed = ObservableBool.new(false)
	pressed.on_set_to_true.connect(func(): on_pressed.emit())
	pressed.on_set_to_false.connect(func(): on_released.emit())

func _input(_event: InputEvent) -> void:
	pressed.Value = Input.is_action_pressed(input)
	
	
