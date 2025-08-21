class_name AreaTrigger extends Area2D

export(NodePath) var objectPath
export(String) var methodName

func _ready():
	collision_layer = 0
	collision_mask = 4096
	
	var _1 = connect("area_entered", self, "entered")

func entered(area : Area2D):
	if area.get_parent().is_in_group("player"):
		if not Network.is_owned(area.get_parent().OwnerID): return
		
		var object := get_node(objectPath)
		if object is EnablePlaceholder:
			object.obj.call(methodName)
		else:
			get_node(objectPath).call(methodName)
	
