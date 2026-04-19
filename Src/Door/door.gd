class_name Door

extends StaticBody2D

@export var open_close_time: float

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var tween: Tween

func open():
	_animate_door_open.call_deferred(true)
	
func close():
	_animate_door_open.call_deferred(false)

func _animate_door_open(_open: bool):
	if (!is_inside_tree()):
		return
		
	if tween != null:
		tween.kill()
	
	collider.disabled = _open
	var final_modulate: Color = Color.TRANSPARENT if _open else Color.WHITE
	tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate", final_modulate, open_close_time).set_ease(Tween.EASE_IN_OUT)
