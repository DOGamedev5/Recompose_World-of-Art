extends HBoxContainer

onready var linkButton = $LinkButton

var webLink : String

func setup(linkName : String, link : String):
	linkButton.text =linkName
	webLink = link

func _on_LinkButton_pressed():
	print(OS.shell_open(webLink))
