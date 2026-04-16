class_name Door

extends StaticBody2D

@export var buttons_needed: int
@export var open_close_time: float

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var buttons_pressed: int
var tween: Tween

func open():
	buttons_pressed += 1
	if (buttons_pressed >= buttons_needed):
		_open_door.call_deferred(true)
	
func close():
	buttons_pressed -= 1
	if (buttons_pressed < buttons_needed):
		_open_door.call_deferred(false)

func _open_door(open: bool):
	if tween != null:
		tween.kill()
	
	collider.disabled = open
	var final_modulate: Color = Color.TRANSPARENT if open else Color.WHITE
	tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate", final_modulate, open_close_time).set_ease(Tween.EASE_IN_OUT)
