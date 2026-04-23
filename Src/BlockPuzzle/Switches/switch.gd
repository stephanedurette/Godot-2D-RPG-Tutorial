class_name Switch

extends StaticBody2D

signal on_toggled_on
signal on_toggled_off

@export var on_at_start: bool
@export var can_interact_at_start: bool

@onready var animated_sprite: AnimatedSprite2D= $"Sprite"

var on: bool
var can_interact: bool

func _ready() -> void:
	on = on_at_start
	can_interact = can_interact_at_start
	_update_animation()

func interact():
	if !can_interact:
		return
	_toggle(!on)

func _emit_state():
	if on:
		on_toggled_on.emit()
	else:
		on_toggled_off.emit()
func _update_animation():
	animated_sprite.play("on" if on else "off")

func _toggle(_on: bool):
	if (_on == on):
		return
		
	on = _on
		
	_update_animation()
	_emit_state()
