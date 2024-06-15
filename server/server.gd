extends Node

var _port = 1234
var _players = 16
var _peer = ENetMultiplayerPeer.new()

func _ready():
	_peer.create_server(_port, _players)
	
	multiplayer.connected_to_server.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_connected)

func _peer_connected(id):
	print("Connected: ", str(id))
	
func _peer_disconnected(id):
	print("Disconnected: " + str(id))
