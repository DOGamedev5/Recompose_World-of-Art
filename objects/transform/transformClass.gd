class_name TransformClass extends Area2D

export(String, FILE, "*.tscn") var transformation

func _ready():
	var _1 = connect("area_entered", self, "areaEntered")

func areaEntered(area):
	print("rodolfo")
	if not (area.is_in_group("player") and area.get_parent().is_in_group("normal")):
		return
	
	print("lodrofo")
	area.get_parent().changePowerup(transformation)
