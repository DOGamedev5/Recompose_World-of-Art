extends CanvasLayer

onready var loadScreen := preload("res://gameplay/loadSystem/loadSystem.tscn")

const MAIN_SCENE := "res://gameplay/MENU/menu.tscn"

func loadScene(current, next : String, currentPath := MAIN_SCENE):
	
	var loadSceneInstance = loadScreen.instance()
	get_tree().get_root().call_deferred("add_child", loadSceneInstance)
	
	var loader := ResourceLoader.load_interactive(next)
	
	if loader == null:
		printerr("failed to load")
		return
	
	current.queue_free()
	
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	var label = loadSceneInstance.get_node("Control/Control/Label")
	
	while true:
		
		var error = loader.poll()
		label.text = str(float(loader.get_stage()) / loader.get_stage_count() * 100) + "%"
		
		if error == OK:
			print(label.text)
		
		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			get_tree().get_root().call_deferred("add_child", scene)
			
			loadSceneInstance.queue_free()
			return
		
		else:
			get_tree().get_root().call_deferred("add_child", load(currentPath))
			
			loadSceneInstance.queue_free()
			return
