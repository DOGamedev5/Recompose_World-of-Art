extends Node


var actions := {}

func _input(event):
	
	for action in InputMap.get_actions():
		if not InputMap.action_has_event(action, event): continue
		
		actions[action] = Global.tree.create_timer(1.5)

func InputPressed(event : String):
	if actions.has(event):
		return actions[event].time_left > 0
	
	return false
