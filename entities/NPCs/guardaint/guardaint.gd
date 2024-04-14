extends NPCBase

export(String) var text

func _ready():
	$interactBallon.changed(text)
	


