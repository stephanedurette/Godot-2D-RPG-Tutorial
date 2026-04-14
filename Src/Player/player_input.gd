extends Node

signal on_move_direction_changed(direction: Vector2)

var move_direction : Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	_update_move_direction()
	
func _update_move_direction():
	var new_move_direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	if (new_move_direction != move_direction):
		move_direction = new_move_direction
		on_move_direction_changed.emit(move_direction)
