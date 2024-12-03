extends CanvasLayer

onready var loadScreen := preload("res://gameplay/loadSystem/loadSystem.tscn")

const MAIN_SCENE := "res://gameplay/MENU/menu.tscn"

var loadSceneInstance

signal finishedLoad()

func _init():
	pause_mode = Node.PAUSE_MODE_PROCESS

func loadScene(current, next : String, closeAfterLoad := false,currentPath := MAIN_SCENE):
	loadSceneInstance = loadScreen.instance()

	get_tree().get_root().call_deferred("add_child", loadSceneInstance)
	
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

func loadObject(object, screen := true):
	
	var label
	var loader := ResourceLoader.load_interactive(object)
	
	if loader == null:
		emit_signal("finishedLoad")
		printerr("failed to load")
		return
	
	if screen:
		label = loadSceneInstance.get_node("Control/Control/Label")
	
	while true:
		
		var error = loader.poll()
		
		if error == OK:
			if screen: label.text = str(float(loader.get_stage()) / loader.get_stage_count() * 100) + "%"
	
		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource()
			emit_signal("finishedLoad")
			return scene
		
		else:
			emit_signal("finishedLoad")
			return

func closeLoad():
	if loadSceneInstance:
		loadSceneInstance.queue_free()

