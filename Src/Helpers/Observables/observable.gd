class_name Observable

signal on_changed(new_value)

var _value

var ValueWithoutNotify:
	set(x):
		if _value != x:
			on_changed.emit(x)
	get:
		return _value

var Value:
	set(x):
		if _value != x:
			_value = x
			on_changed.emit(x)
	get:
		return _value
			
			
func _init(starting_value) -> void:
	_value = starting_value
	
func notify():
	on_changed.emit(_value)
