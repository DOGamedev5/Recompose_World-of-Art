extends Node

onready var loaded := {}
onready var toLoad := {}
onready var loaders := []
onready var totalSegments := 0
onready var currentSegments := 0
onready var alreadyLoaded := 0

signal allTexturesLoaded

func loadDirectory(DirPath : String, texturesReference : String, extension := ".png", deep := -1):
	var dir := Directory.new()
	toLoad[texturesReference] = {}
	
	if not dir.dir_exists(DirPath):
		push_error("Invalid path: {%s}" % DirPath)
		return
	
	var error := dir.open(DirPath)
	if error != OK:
		push_error("Error when opening \"{dir}\": {error}".format({"dir" : DirPath, "error" : error}))
		return
	
	call_deferred("_load", DirPath, texturesReference, extension, deep)

func _load(DirPath : String, reference : String, extension : String, deep : int, step := -1):
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
		if dir.current_is_dir() and not (deep != -1 and deep < step):
			var newPath := DirPath
			if not DirPath.ends_with("/"): newPath += "/"
			newPath += file_name + "/"
			_load(newPath, reference, extension, deep, step+1)
			file_name = dir.get_next()
			
			continue
		
		if not file_name.ends_with(extension):
			file_name = dir.get_next()
			continue
		
		toLoad[reference][DirPath + file_name] = DirPath + file_name
		
		file_name = dir.get_next()
	

func process():
	if toLoad.size() > 0:
		for item in toLoad.keys():
			for path in toLoad[item].keys():
				loaders.append({"path" : path, "load" : ResourceLoader.load_interactive(path)})
				totalSegments += loaders[0]["load"].get_stage_count()
				
		toLoad.clear()
	
	elif loaders.size() > 0:
		var error = loaders[0]["load"].poll()

		if error == OK:
			currentSegments += 1
#			if label: label.text = "%0d%%" % (float(loader.get_stage()) / loader.get_stage_count() * 100)
#
		elif error == ERR_FILE_EOF:
			alreadyLoaded += 1
			currentSegments += 1
			var result = loaders[0]["load"].get_resource()
			loaded[loaders[0]["path"]] = result
			loaders.remove(0)
			if loaders.size() == 0:
				emit_signal("allTexturesLoaded")

		else:
			push_error("erro when loading '{0}', error {1}".format([loaders[0]["path"], error]))

