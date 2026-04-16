extends Node

@export var buttons: Array[PushButton]

@onready var _requiredButtons = buttons.size()

signal on_all_buttons_pressed
signal on_some_buttons_pressed
signal on_none_buttons_pressed

var _current_pressed_buttons: int

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(_on_button_pressed)
		button.unpressed.connect(_on_button_unpressed)
	
func _on_button_pressed():
	_current_pressed_buttons += 1
	if (_current_pressed_buttons >= _requiredButtons):
		on_all_buttons_pressed.emit()
	
func _on_button_unpressed():
	_current_pressed_buttons -= 1
	if (_current_pressed_buttons == 0):
		on_none_buttons_pressed.emit()
	else:
		on_some_buttons_pressed.emit()
