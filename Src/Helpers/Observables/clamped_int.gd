class_name ClampedInt

var value: Observable
var max_value: Observable
var min_value: Observable

const INT_MAX = 9223372036854775807

var Value:
	set(x):
		value.Value = clampi(x, min_value.Value, max_value.Value)
	get:
		return value.Value

var MinValue:
	set(x):
		min_value.Value = x
	get:
		return min_value.Value

var MaxValue:
	set(x):
		max_value.Value = x
	get:
		return max_value.Value	

func _init(_starting_value: int = 0, _min_value: int = 0, _max_value: int = INT_MAX) -> void:
	value = Observable.new(_starting_value)
	min_value = Observable.new(_min_value)
	max_value = Observable.new(_max_value)
	
