extends CanvasLayer

var oldFocusOwner : Control

func trigger():
	visible = true
	
	oldFocusOwner = get_parent().current.get_focus_owner()
	
	$Panel/margin/VBoxContainer/HBoxContainer/no.grab_focus()

func _on_no_pressed():
	visible = false
	
	oldFocusOwner.grab_focus()

func _on_yes_pressed():
	get_tree().quit()
