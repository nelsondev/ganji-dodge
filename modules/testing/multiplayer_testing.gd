extends Node2D

var _peer = ENetMultiplayerPeer.new()
var _server_id = -1

func _ready():
	_peer.create_client("localhost", 5000)
	
	multiplayer.multiplayer_peer = _peer
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	multiplayer.connection_failed.connect(_failed)
	
func _connected():
	print("Connected!")
	
func _disconnected(): 
	print("Disconnected")
	
func _failed():
	print("Failed")
	
@rpc("any_peer", "reliable", "call_remote")
func _register(player_data):
	print("Sent player data...")
