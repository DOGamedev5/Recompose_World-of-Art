extends Node
class_name PlayerInfo

### Save variables
export var playerName := "New Player"
export var character := "lodrofo"
export var colorShift := 0
export var type := 0
export var netOwner := -1

### Client Variables
var reference : Node
var loadedRooms := []

