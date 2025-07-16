class_name ColorButton extends Panel

export var color : Color setget _colorChange
export(int, 0, 360, 0) var hueShift := 0
export var toggled := false setget _toggled

signal selected(hueValue)

func _colorChange(value):
	self["custom_styles/panel"].bg_color = value
	color = value

func _toggled(value):
	toggled = value
	$button.pressed = value
	if not value or not is_instance_valid(get_parent()): return
	emit_signal("selected", hueShift)
	for child in get_parent().get_children():
		if child.has_method("_colorChange") and child != self:
			child.toggled = false
