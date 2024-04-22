extends Node2D

export(String, FILE) var roomPath
export var roomId := 0
export var world := "paintWorld"
export(String, "rooms", "especialRooms") var roomType = "rooms"

func saveData(_player):
	var data = Global.save
	
	data.player["position"] = position
	
	data.world["currentRoomID"] = roomId
	data.world["currentWorld"] = world
	data.world["currentTypeRoom"] = roomType
	if roomPath:
		data.world["currentRoomPath"] = roomPath
	
	data.played = true
	
	Global.saveGameData(Global.savePath, data)
	
