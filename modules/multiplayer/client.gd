extends Node

var _peer = ENetMultiplayerPeer.new()
var _tickrate = 30
var _tick_timer = Timer.new()

func _ready():
	
	_peer.create_client("localhost", 5000)
	
	# Setup multiplayer events
	multiplayer.multiplayer_peer = _peer
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	multiplayer.connection_failed.connect(_failed)
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	
	# Setup tick function
	_tick_timer.one_shot = false
	_tick_timer.wait_time = 1.0 / _tickrate
	_tick_timer.timeout.connect(_tick)
	add_child(_tick_timer)

func _tick():
	Server._sync.rpc({ 
		"global_position": Game.get_player().global_position,
		"left_controller": {
			"pos": Game.get_left_controller().global_position,
			"rot": Game.get_left_controller().global_rotation
		},
		"right_controller": {
			"pos": Game.get_right_controller().global_position,
			"rot": Game.get_right_controller().global_rotation
		}
	})	

func _connected():
	print("Connected!")
	_tick_timer.start()
	
func _disconnected(): 
	print("Disconnected")
	
func _failed():
	print("Failed")
	
func _peer_connected(id):
	if id == 1: return
	if id == multiplayer.get_unique_id(): return
	var players = Game.get_players()
	var dummy = load("res://modules/player_dummy/player_dummy.tscn").instantiate()
	dummy.name = str(id)
	players.add_child(dummy)

func _peer_disconnected(id):
	if id == 1: return
	if id == multiplayer.get_unique_id(): return
	var dummy = Game.get_dummy(str(id))
	if dummy: dummy.queue_free()

@rpc("authority", "unreliable", "call_local")
func _sync(players: Dictionary):
	players.erase(multiplayer.get_unique_id())
	for key in players.keys():
		var dummy = Game.get_dummy(str(key))
		var data = players[key]
		dummy.syncronize(data)
