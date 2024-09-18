class_name RoomData extends Resource

export(String) var roomPath
export(String) var world
export(String) var category
export(int) var ID := 0
export(int) var warpID
export(String) var warpType

export var debugMode := false

export var data := {
	"destroiedBlocks" : [],
	"collectedCoins" : []
}

export(String) var savePath 
export(String) var saveWorldPath 

func _init(roomID := 0, worldPath : String = "res://worlds/sandDesert", Category : String = "rooms", path := "res://worlds/sandDesert/especialRooms/welcome/welcome.tscn", WarpID := 0, WarpType := "warp", debug := false):
	debugMode = debug
	
	if roomID != 0:
		path = "{world}/{category}/room{room}.tscn".format({
			"world" : worldPath,
			"category" : Category,
			"room" : roomID
		})
	
	roomPath = path
	world = worldPath
	category = Category
	ID = roomID
	warpID = WarpID
	warpType = WarpType
	
	if world.get_base_dir() != "res://dimensions" and category == "rooms":
		saveWorldPath = Global.savePath + "worldRooms" + world.substr(12)  + "/rooms"
		
		savePath = saveWorldPath + "/room{index}.tres".format({"index" : ID})

func addToRoomData(obj_name : String, catergory : String):
	if not obj_name in data[catergory]:
		data[catergory].append(obj_name)

func saveDataRoom():
	verifyDirs()

	if world.get_base_dir() == "res://dimensions":
		Global.dimensionsRooms[ID] = self.duplicate(true)
		
		return
		
	var path : String= "worldRooms/"+ world.substr(13) + "/rooms/"

	Global.roomsToSave[path + "room{0}.tres".format([ID])] = self

func loadDataRoom():
	verifyDirs()
	
	if world.get_base_dir() == "res://dimensions":
		if Global.dimensionsRooms.has(ID):
			data = Global.dimensionsRooms[ID].data
		else:
			for key in data.keys():
				data[key].clear()
		
		return
	
	if Global.roomsToSave.has(savePath):
		data = Global.roomsToSave[savePath].data
	elif Global.saveExist(savePath):
		data = Global.loadData(savePath).data
	
	
func verifyDirs():
	var dir := Directory.new()
	if dir.open(Global.savePath) != OK:
		return
	
	for item in ["worldRooms", world.substr(13), "rooms"]:
		if world.get_base_dir() == "res://dimensions":
			break
		
		if not dir.dir_exists(item):
			var ERROR := dir.make_dir(item)
			if ERROR:
				print_debug("making {world} path gives the error: {error}".format(
					{"world" : item, "error" : ERROR})
				)
				break
		
		dir.change_dir(item)
