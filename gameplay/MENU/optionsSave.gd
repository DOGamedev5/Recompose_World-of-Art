class_name OptionsSave extends Resource

export var simpleLight := false
export var shadows := false
export var musicVolume := 0.75
export var sfxVolume := 0.90
export var useThreadForLights := true
export var vsync := 0
export var lang : String

func _ready():
	var _1 := connect("changed", self, "save")
	print("a")

func save():
	print("A")
