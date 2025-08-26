class_name CanvasModulaterChanger extends Area2D

export var colorChange := Color.white

func _init():
	collision_layer = 0
	collision_mask = 4096
	connect("area_entered", self, "playerEntered")
	connect("area_exited", self, "playerExited")

func playerEntered(area):
	if area.get_parent().is_in_group("player"):
		if Network.is_owned(area.get_parent().OwnerID):
			Global.world.setCanvasModulate(colorChange)

func playerExited(area):
	if area.get_parent().is_in_group("player"):
		if Network.is_owned(area.get_parent().OwnerID):
			Global.world.setCanvasModulate()
