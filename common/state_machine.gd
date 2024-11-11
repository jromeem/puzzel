# state_machine.gd
class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			var state_name = child.name.to_lower().replace(' ', '_')
			states[state_name] = child
			child.Transitioned.connect(on_child_transitioned)
	
	if initial_state:
		current_state = initial_state

func _process(delta: float):
	if current_state:
		current_state.Update(delta)
	else:
		pass
		#print("No current state!")

func _physics_process(delta: float):
	if current_state:
		current_state.Physics_update(delta)

func on_child_transitioned(state, new_state_name):
	#print("Transition requested from ", state.name, " to ", new_state_name)
	
	if state != current_state:
		#print("State requesting transition is not current state!")
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		#print("Could not find new state: ", new_state_name)
		#print("Available states: ", states.keys())
		return
		
	if current_state:
		current_state.Exit()
		
	current_state = new_state
	new_state.Enter()
