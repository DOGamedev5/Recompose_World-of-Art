extends Node

onready var textures := {}
onready var texturesToLoad := {}
onready var loaders := []
onready var totalSegments := 0
onready var currentSegments := 0

signal allTexturesLoaded

func loadTexturesOnDirectory(DirPath : String, texturesReference : String):
	var dir := Directory.new()
	texturesToLoad[texturesReference] = {}
	
	if not dir.dir_exists(DirPath):
		push_error("Invalid path: {%s}" % DirPath)
		return
	
	var error := dir.open(DirPath)
	if error != OK:
		push_error("Error when opening \"{dir}\": {error}".format({"dir" : DirPath, "error" : error}))
		return
	
	call_deferred("_loadTextures", DirPath, texturesReference)

func _loadTextures(DirPath : String, reference : String):
	var dir := Directory.new()
	
	var error := dir.open(DirPath)
	if error != OK:
		push_error("Error when opening \"{dir}\": {error}".format({
			"dir" : DirPath,
			"error" : error
		}))
		return
	
	dir.list_dir_begin(true)
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			var newPath := DirPath
			if not DirPath.ends_with("/"): newPath += "/"
			newPath += file_name + "/"
			_loadTextures(newPath, reference)
			file_name = dir.get_next()
			
			continue
		
		if not file_name.ends_with(".png"):
			file_name = dir.get_next()
			continue
		
		texturesToLoad[reference][DirPath + file_name] = DirPath + file_name
		
		file_name = dir.get_next()

func process():
	if texturesToLoad.size() > 0:
		for item in texturesToLoad.keys():
			for path in texturesToLoad[item].keys():
				loaders.append({"path" : path, "load" : ResourceLoader.load_interactive(path)})
				totalSegments += loaders[0]["load"].get_stage_count()
				
		texturesToLoad.clear()
	
	elif loaders.size() > 0:
		var error = loaders[0]["load"].poll()

		if error == OK:
			currentSegments += 1
#			if label: label.text = "%0d%%" % (float(loader.get_stage()) / loader.get_stage_count() * 100)
#
		elif error == ERR_FILE_EOF:
			currentSegments += 1
			var result = loaders[0]["load"].get_resource()
			textures[loaders[0]["path"]] = result
			loaders.remove(0)
			if loaders.size() == 0:
				emit_signal("allTexturesLoaded")

		else:
			push_error("erro when loading '{0}', error {1}".format([loaders[0]["path"], error]))

