class_name AreaTrigger extends Area2D

export(NodePath) var objectPath
export(String) var methodName

func _ready():
	collision_layer = 1024
	collision_mask = 0
	
	var _1 = connect("area_entered", self, "entered")

func entered(area : Area2D):
	if area.get_parent().is_in_group("player"):
		var object := get_node(objectPath)
		if object is EnablePlaceholder:
			object.obj.call(methodName)
		else:
			get_node(objectPath).call(methodName)
	
