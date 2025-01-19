class_name enablePlaceholder extends VisibilityNotifier2D

export var placeholderPath : NodePath
onready var placeholder := get_node(placeholderPath) as InstancePlaceholder
onready var scene : Node

func _ready():
	connect("screen_entered", self, "activaded")
	
func activaded():
	connect("screen_exited", placeholder.create_instance(), "queue_free")
