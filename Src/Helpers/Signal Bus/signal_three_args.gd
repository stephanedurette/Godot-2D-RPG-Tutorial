class_name SignalThreeArgs

extends Resource

signal _signal(arg, arg1, arg2)

func emit(arg, arg1, arg2):
	_signal.emit(arg, arg1, arg2)
	
func connect_signal(c: Callable):
	_signal.connect(c)
