extends Node

var _port = 5000
var _max_players = 16
var _peer = ENetMultiplayerPeer.new()
var started = Time.get_unix_time_from_system()

var _tickrate = 30
var _tick_timer = Timer.new()

var _players: Dictionary = {}

func _ready():
	print("Starting server...")
	print("\tPORT: ", _port)
	print("\tMAX_PLAYERS: ", _max_players)
	print("\tTICK_RATE: ", _tickrate)
	
	_peer.create_server(_port, _max_players)
	
	multiplayer.multiplayer_peer = _peer
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	# Setup tick function
	_tick_timer.one_shot = false
	_tick_timer.wait_time = 1.0 / _tickrate
	_tick_timer.timeout.connect(_tick)
	add_child(_tick_timer)
	_tick_timer.start()
	
	print("Server ready for connection in ", Time.get_unix_time_from_system() - started, " ms.")

func _tick():
	Client._sync.rpc(_players)

func _peer_connected(id):
	_players[id] = {}
	print("Connected: ", str(id))
	
func _peer_disconnected(id):
	_players.erase(id)
	print("Disconnected: " + str(id))

func _find_player(id):
	for player in _players:
		if player.id == id:
			return player
	return null

@rpc("any_peer", "unreliable_ordered", "call_remote")
func _sync(data):
	_players[multiplayer.get_remote_sender_id()] = data
