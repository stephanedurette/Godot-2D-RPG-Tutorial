extends Observable

signal on_set_to_true
signal on_set_to_false

func _init(starting_value: bool) -> void:
	super._init(starting_value)
	on_changed.connect(_on_changed)
	
func _on_changed(new_value: bool):
	if (new_value):
		on_set_to_true.emit()
	else:
		on_set_to_false.emit()
