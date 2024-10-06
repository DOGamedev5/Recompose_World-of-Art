class_name TextDialog extends Resource

export var text : String
export var name : String
export(Array, String) var options := []
export var imageId := 0
export var react := 0

func _init(Text := "", Name := "", Options := [], ImageID := -1, React := 0):
	text = Text
	options = Options
	name = Name
	imageId = ImageID
	react = React
