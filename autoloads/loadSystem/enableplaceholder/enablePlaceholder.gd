class_name EnablePlaceholder extends Area2D

export var placeholderPath : NodePath
export var collisionShapePath : NodePath
onready var placeholder := get_node(placeholderPath) as InstancePlaceholder
onready var scene : PackedScene
onready var obj
onready var vision : VisibilityNotifier2D

var playersInside := []

func _init():
	monitoring = false

func _ready():
	set_collision_layer(0)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(12, true)
	vision = VisibilityNotifier2D.new()
	
	var collisionShape := get_node_or_null(collisionShapePath)
	if collisionShape:
		vision.position = collisionShape.position
		vision.rect.position.x = -(collisionShape.shape.extents.x)
		vision.rect.position.y = -(collisionShape.shape.extents.y)
		vision.rect.size.x = 2*(collisionShape.shape.extents.x)
		vision.rect.size.y = 2*(collisionShape.shape.extents.y)
		add_child(vision)

	vision.connect("screen_entered", self, "enteredScreen")
	vision.connect("screen_exited", self, "exitedScreen")
	connect("area_entered", self, "activaded")
	connect("area_exited", self, "exited")
	
	set_deferred("monitoring", true)
	
func activaded(area : Area2D):
	if area.is_in_group("player"):
		playersInside.append(area)
	
		if not is_instance_valid(obj): obj = placeholder.create_instance(false, scene)

func enteredScreen():
	if not is_instance_valid(obj):
		obj = placeholder.create_instance(false, scene)
		
		get_parent().roomLoaded(placeholder.name)
		print(get_parent().loadedRooms)
	
func exited(area : Area2D):
	if is_instance_valid(obj) and not area.is_in_group("player"): return
	if playersInside.has(area): playersInside.erase(area)
	get_parent().roomUnloaded(placeholder.name)
	
	if playersInside.size() == 0 and not vision.is_on_screen():
		scene = PackedScene.new()
		scene.pack(obj)
		if obj: obj.queue_free()

func exitedScreen():
	if playersInside.size() > 0 or not is_instance_valid(obj): return
	scene = PackedScene.new()
	scene.pack(obj)
	obj.queue_free()
