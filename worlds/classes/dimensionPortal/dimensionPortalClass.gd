class_name DimensionPortal extends PathBase

export var hudPortalPath : NodePath
var hudPortal

func _ready():
	warpType = "portal"
	hudPortal = get_node(hudPortalPath)
	
	var _1 = hudPortal.connect("interacted", self, "changeRoom")
