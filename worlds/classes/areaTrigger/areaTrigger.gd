class_name AreaTrigger extends Area2D

export(NodePath) var objectPath
export(String) var methodName
export(Array) var binds := []

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
			var obj := get_node_or_null(objectPath)
			if obj:
				if obj.has_method(methodName): obj.callv(methodName, binds)
	
