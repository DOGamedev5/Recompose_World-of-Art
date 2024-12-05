extends CanvasLayer

onready var loadScreen := preload("res://gameplay/loadSystem/loadSystem.tscn")

const MAIN_SCENE := "res://gameplay/MENU/menu.tscn"

var loadSceneInstance
var time_max = 100 

onready var queueLoad := []

signal finishedLoad()

class QueueObject:
	extends Node
	
	enum {
		PROPERTY
		SCENECHANGE
		ADDSCENE
	}
	
	var path : String
	var receive : Object
	var type := PROPERTY
	var property : String
	var loader : ResourceInteractiveLoader
	var deffered := false
	var tree 
	var aditionalFlags := {}
	
	func _init(objectPath, flags := {}):
		path = objectPath
		type = flags.type
		
		if type == PROPERTY:
			property = flags.property
			receive = flags.receiver
			
		elif type == ADDSCENE:
			receive = flags.receiver
			deffered = flags.deffered
			aditionalFlags = flags.addFlags
			
		else:
			receive = flags.receiver
			tree = flags.tree
		
		loader = ResourceLoader.load_interactive(objectPath)
	
	func end(result):
		if type == PROPERTY:
			receive.set(property, result)
			
		elif type == SCENECHANGE:
			tree.current_scene.queue_free()
			receive.call_deferred("add_child", result)
			tree.set_deferred("current_scene", result)
			
		else:
			if deffered:
				receive.call_deferred("add_child", result)
				
			else:
				receive.add_child(result)
			
			if aditionalFlags.property:
				aditionalFlags.receiver.set(aditionalFlags.property, result)
				

func _init():
	pause_mode = Node.PAUSE_MODE_PROCESS

func openScreen():
	if loadSceneInstance: return
	
	loadSceneInstance = loadScreen.instance()
	get_tree().get_root().call_deferred("add_child", loadSceneInstance)
	set_process(true)

func closeLoad():
	if loadSceneInstance:
		loadSceneInstance.queue_free()
	emit_signal("finishedLoad")
	set_process(false)

func addToQueueProperty(path, object, objectProperty):
	queueLoad.append(QueueObject.new(path, {type = 0, receiver = object, property = objectProperty}))

func addToQueueChangeScene(path):
	queueLoad.append(QueueObject.new(path, {type = 1, receiver = get_tree().get_root(), tree = get_tree()}))

func addToQueueAddScene(path, object, addDeffered := false, flags := {property = null, propertyReceiver = null}):
	queueLoad.append(QueueObject.new(path, {type = 2, receiver = object, deffered = addDeffered, addFlags = flags}))

func _process(_delta):
	if not queueLoad:
		closeLoad()
		return
	
	var loader : ResourceInteractiveLoader = queueLoad[0].loader
	
	if loader == null:
		emit_signal("finishedLoad")
		printerr("failed to load, null loader")
		return
	
	var label = loadSceneInstance.get_node("Control/Control/Label")
	
	var t = OS.get_ticks_msec()

	while OS.get_ticks_msec() < t + time_max:
		var error = loader.poll()
		
		if error == OK:
			label.text = str(float(loader.get_stage()) / loader.get_stage_count() * 100) + "%"

		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			queueLoad[0].end(scene)
			queueLoad.pop_front()
			
			break
			
		else:
			push_error("erro when loading '{0}', error {1}".format([queueLoad[0].path, error]))
	
	pass

func loadScene(current, next : String, closeAfterLoad := false,currentPath := MAIN_SCENE):
	openScreen()
	
	var loader := ResourceLoader.load_interactive(next)
	
	if loader == null:
		emit_signal("finishedLoad")
		printerr("failed to load")
		return
	
	current.queue_free()
	
	var label = loadSceneInstance.get_node("Control/Control/Label")
	
	while true:
		var error = loader.poll()
		
		if error == OK:
			label.text = str(float(loader.get_stage()) / loader.get_stage_count() * 100) + "%"

		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			emit_signal("finishedLoad")
			get_tree().get_root().call_deferred("add_child", scene)
			get_tree().set_deferred("current_scene", scene)
			
			if closeAfterLoad:
				closeLoad()
			
			return
		
		else:
			get_tree().get_root().call_deferred("add_child", load(currentPath))
			emit_signal("finishedLoad")
			closeLoad()
			
			return
