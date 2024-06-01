class_name Question extends Resource

export(String, MULTILINE) var question
export(Array, String) var options

func _init(quest : String = question, optionsList : Array = options):
	question = quest
	options = optionsList
