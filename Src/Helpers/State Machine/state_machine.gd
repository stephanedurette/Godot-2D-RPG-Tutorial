class_name State_Machine
var current_state: State
	
func change_state(new_state: State):
	if (new_state == current_state):
		return
			
	if(current_state != null):
		current_state.exit()
			
	current_state = new_state
		
	if(current_state != null):
		current_state.enter()
