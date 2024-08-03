class_name RoomData extends Resource

export(String) var roomPath
export(String) var world
export(String) var category
export(int) var ID
export(int) var warpID
export(String) var warpType

export var debugMode := false

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
