class_name SaveResource extends Resource

export var saveID := 1
var save

export var player := {
	"position" : Vector2(-16, -96)
}

export var world := {
	"currentWorld" : "paintWorld",
	"currentRoomID" : 1,
	"paintWorld" : {
		"colliseun" : false
	}
}

func _ready():
	save = "res://gameplay/saves/data/save%d.tres" % saveID
	
