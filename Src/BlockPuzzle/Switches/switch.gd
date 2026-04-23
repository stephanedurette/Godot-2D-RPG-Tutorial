extends StaticBody2D

signal on_toggled_on
signal on_toggled_off

@export var on_at_start: bool

@onready var animated_sprite: AnimatedSprite2D= $"Sprite"

var on: bool

func _ready() -> void:
	_toggle(on_at_start)

func interact():
	_toggle(!on)

func _toggle(_on: bool):
	if (_on == on):
		return
	
	on = _on
	
	animated_sprite.play("on" if on else "off")
	if on:
		on_toggled_on.emit()
	else:
		on_toggled_off.emit()
