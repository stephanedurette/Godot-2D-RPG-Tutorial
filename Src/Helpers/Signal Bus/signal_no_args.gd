class_name SignalNoArgs

extends Resource

signal _signal

func emit():
	_signal.emit()
	
func connect_signal(c: Callable):
	_signal.connect(c)
