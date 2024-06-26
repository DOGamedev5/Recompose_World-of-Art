class_name SaveGame extends Resource

export var played := false

var player := {
	"position" : Vector2(664, -64),
	"playerProperties" : {
		"name" : "Doe"
	}
}

var world := {
	"currentRoom" : RoomData.new(0, "res://worlds/sandDesert", "especialRooms", "res://worlds/sandDesert/especialRooms/welcome/welcome.tscn", 0, "warp"),
	"paintWorld" : {
		"colliseun" : false
	}
}

	
