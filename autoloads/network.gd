extends Node



####################
######OLD CODE######
####################
#var IP_address := ""
#const DEFAULT_PORT = 28960
#const MAX_PLAYERS = 4
#
#var client : NetworkedMultiplayerENet
#var server : NetworkedMultiplayerENet
#
#func _ready():
#	if OS.get_name() == "Android":
#		IP_address = IP.get_local_addresses()[0]
#	else:
#		IP_address = IP.get_local_addresses()[3]
#
#	for ip in IP.get_local_addresses():
#		if ip.begins_with("192.168"):
#			IP_address = ip
#
#	get_tree().connect("connected_to_server", self, "_connected_to_server")
#	get_tree().connect("server_disconnected", self, "_server_disconnected")
#
#func createServer() -> int:
#	server = NetworkedMultiplayerENet.new()
#	var error := server.create_server(DEFAULT_PORT, MAX_PLAYERS)
#	if error == OK: get_tree().set_network_peer(server)
#
#	return error
#
#func enterServer() -> int:
#	client = NetworkedMultiplayerENet.new()
#	var error := client.create_client(IP_address, DEFAULT_PORT)
#	if error == OK: 
#
#		get_tree().set_network_peer(client)
#
#	return error
#
#func _connected_to_server():
#	print("A")
#
#func _server_disconnected():
#	get_tree().network_peer = null
#	if OS.get_name() == "Android":
#		IP_address = IP.get_local_addresses()[0]
#	else:
#		IP_address = IP.get_local_addresses()[3]
#
#	for ip in IP.get_local_addresses():
#		if ip.begins_with("192.168"):
#			IP_address = ip
