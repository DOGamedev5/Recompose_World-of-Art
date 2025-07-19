extends CanvasLayer

const MAIN_SCENE := "res://gameplay/MENU/menu.tscn"

var time_max = 100 

onready var queueLoad := []

signal finishedLoad()
signal objectLoaded(object)

class QueueObject:
	extends Node
	
	enum {
		PROPERTY
		SCENECHANGE
		ADDSCENE
		DICTIONARY
	}
	
	var path : String
	var propertyReceiver : Object
	var sceneReceiver : Object
	var type := PROPERTY
	var property : String
	var propertyKey : String
	var scene
	var loader : ResourceInteractiveLoader
	var deffered := false
	
	func _init(objectPath, flags := {}):
		path = objectPath
		type = flags.type
		
		if flags.has("property"):
			property = flags.property
			propertyReceiver = flags.propertyReceiver
			
		if flags.has("sceneReceiver"):
			sceneReceiver = flags.sceneReceiver
			deffered = flags.deffered
		
		if flags.has("propertyKey"):
			propertyKey = flags.propertyKey
		
		createLoader()
		
	func createLoader():
		loader = ResourceLoader.load_interactive(path)
	
	func end(result):
		if sceneReceiver:
			if type == 1:
				propertyReceiver.current_scene.queue_free()
			elif type == 3:
				propertyReceiver.loadedObject(propertyKey, result)
			
			if deffered:
				sceneReceiver.call_deferred("add_child", result)
				
			else:
				sceneReceiver.add_child(result)
			
		if propertyReceiver: propertyReceiver.set(property, result)

func _init():
	pause_mode = Node.PAUSE_MODE_PROCESS

func openScreen():
	set_process(true)
	LoadScreen.visible = true

func closeLoad():
	LoadScreen.visible = false
	emit_signal("finishedLoad")
	set_process(false)

func addToQueueProperty(path, object, objectProperty):
	queueLoad.append(QueueObject.new(path, {
		type = 0,
		propertyReceiver = object,
		property = objectProperty
	}))

func addToQueueChangeScene(path):
	
	queueLoad.append(QueueObject.new(path, {
		type = 1,
		property = "current_scene",
		propertyReceiver = Global.tree,
	}))

func addToQueueAddScene(path : String, objectReceiver : Object, addDeffered := false, property := "", propertyReceiver : Object = null):
	queueLoad.append(QueueObject.new(path, {
		type = 2,
		sceneReceiver = objectReceiver,
		property = property,
		propertyReceiver = propertyReceiver,
		deffered = addDeffered
	}))

func _process(_delta):
	if not queueLoad:
		closeLoad()
		return
	
	var loader : ResourceInteractiveLoader = queueLoad[0].loader
	
	if loader == null:
		if not FileSystemHandler.fileExist(queueLoad[0].path):
			printerr("failed to load, '%s' do not exist" % queueLoad[0].path)
		else:
			printerr("failed to load, null loader")
			
		queueLoad[0].createLoader()
		return
	
	var label : Label
	label = LoadScreen.get_node("Control/Control/Label")
	
	var error = loader.poll()
	
	if error == OK:
		if label: label.text = "%0d%%" % (float(loader.get_stage()) / loader.get_stage_count() * 100)

	elif error == ERR_FILE_EOF:
		var result = loader.get_resource()
		
		if queueLoad[0].type == 1:
			Global.tree.change_scene_to(result)
		else:
			queueLoad[0].end(result.instance())
		
		queueLoad[0].queue_free()
		queueLoad.pop_front()
		
		emit_signal("objectLoaded", result)
#		break
		
	else:
		push_error("erro when loading '{0}', error {1}".format([queueLoad[0].path, error]))
	
	
