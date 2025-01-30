class_name enablePlaceholder extends VisibilityNotifier2D

export var placeholderPath : NodePath
onready var placeholder := get_node(placeholderPath) as InstancePlaceholder
onready var scene : PackedScene
onready var obj

func _ready():
	connect("screen_entered", self, "activaded")
	connect("screen_exited", self, "exited")
	
func activaded():
	obj = placeholder.create_instance(false, scene)
	
func exited():
	if not obj: return
	scene = PackedScene.new()
	scene.pack(obj)
	obj.queue_free()
	
