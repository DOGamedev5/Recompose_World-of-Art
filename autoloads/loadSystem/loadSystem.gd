extends Node

const MAIN_SCENE := "res://gameplay/MENU/menu.tscn"

var time_max = 100 

onready var queueLoad := []

onready var playersRemaining := []

signal finishedLoad()
signal objectLoaded(object)

#var addToScene := Thread.new()

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
	var finished := false
	
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

func _ready():
	Network.connect("memberLeft", self, "playerReady")

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
		if label: label.text = "100%"
		if label: label.text = "wainting other players... %d/%d" % [Players.playerList.keys().size() - playersRemaining.size(), Players.playerList.keys().size()]
		
		var result = loader.get_resource()
		
		
		if queueLoad[0].type == 1 and not queueLoad[0].finished:
			Global.tree.change_scene_to(result)
		
		elif not queueLoad[0].finished:
			queueLoad[0].end(result.instance())
		
		queueLoad[0].finished = true
		
		if queueLoad[0].type == 1 and playersRemaining:
			Global.tree.paused = true
			Network.callRemote("playerReady", get_path(), [Network.steamID])
#			callv("playerReady", [Network.steamID])
			playerReady(Network.steamID)
			if playersRemaining:
				if label: label.text = "wainting other players... %d/%d" % [Players.playerList.keys().size() - playersRemaining.size(), Players.playerList.keys().size()]
				return
			else:
				Global.tree.paused = false
		
		queueLoad[0].queue_free()
		queueLoad.pop_front()
		
		emit_signal("objectLoaded", result)
#		break
		
	else:
		push_error("erro when loading '{0}', error {1}".format([queueLoad[0].path, error]))
	
func startWaitingOthers():
	playersRemaining.clear()
	for member in Players.playerList:
		playersRemaining.append(member)

func playerReady(id):
	playersRemaining.erase(id)

