extends VBoxContainer

export(Array, StreamTexture) var images
export(Dictionary) var links

export var Name := "Name"

var linkButton = preload("res://gameplay/MENU/creditsPaint/links/link.tscn")

func _ready():
	$Label3.text = Name + ":"
	
	for image in images:
		var newImage = TextureRect.new()
		newImage.texture = image
		add_child(newImage)
	
	for link in links.keys():
		var newLinkButton = linkButton.instance()
		add_child(newLinkButton)
		newLinkButton.setup(link, links[link])
