class_name SignalOneArg

extends Resource

signal _signal(arg)

func emit(arg):
	_signal.emit(arg)
	
func connect_signal(c: Callable):
	_signal.connect(c)
