extends Node

@export var switches: Array[Switch]
@export var solve_states: Array[bool]
@export var one_shot_puzzle: bool 

signal puzzle_solved
signal puzzle_unsolved

func _ready() -> void:
	for s in switches:
		s.on_toggled_on.connect(_on_switch_state_changed)
		s.on_toggled_off.connect(_on_switch_state_changed)
	
func _on_switch_state_changed():
	if _is_puzzle_solved():
		puzzle_solved.emit()
		if one_shot_puzzle:
			_enable_all_switches(false)
	else:
		puzzle_unsolved.emit()

func _enable_all_switches(enable: bool):
	for i in switches:
		i.can_interact = enable

func _is_puzzle_solved() -> bool:
	for i in solve_states.size():
		if switches[i].on != solve_states[i]:
			return false
	return true
