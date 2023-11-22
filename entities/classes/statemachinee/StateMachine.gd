class_name StateMachine extends Node

export(NodePath) var startingState

var currentState : State

var states : Dictionary

func init(parent, state := currentState):

	for child in get_children():
		states[child.name] = child
		child.parent = parent
	
	currentState = state
	
	currentState = get_node(startingState)
	currentState.enter()

func changeState(newState : String):
	if currentState:
		currentState.exit()
	
	currentState = get_node(newState)
	currentState.enter()

func processMachine(delta):
	var newState = currentState.process_state()
	if newState != null:
		changeState(newState)
	currentState.process_physics(delta)
