extends Node

signal connected
signal connect_failed
signal disconnected

var _peer = ENetMultiplayerPeer.new()
var _tickrate = 30
var _tick_timer = Timer.new()

var failed = false

func _connect(ip):
	_peer.create_client(ip, 5000)
	
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

func _disconnect():
	_tick_timer.stop()
	multiplayer.multiplayer_peer = null
	await get_tree().create_timer(0.1).timeout
	_disconnected()

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
	await get_tree().create_timer(0.1).timeout
	connected.emit()
	_tick_timer.start()
	Voip.add_voip()
	
func _disconnected(): 
	print("Disconnected")
	disconnected.emit()
	for player in Game.get_players().get_children():
		player.queue_free()
	Voip.remove_voip()
	
func _failed():
	await get_tree().create_timer(0.1).timeout
	failed = true
	connected.emit()
	connect_failed.emit()
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
		
@rpc("any_peer", "reliable", "call_remote")
func _voip(data: PackedVector2Array, buffer_size):
	var dummy = Game.get_dummy(str(multiplayer.get_remote_sender_id()))
	var dummy_voice = dummy.get_node("Voice") as AudioStreamPlayer3D
	if not dummy_voice.get_stream_playback().can_push_buffer(buffer_size): return
	for i in range(0, buffer_size):
		dummy_voice.get_stream_playback().push_frame(data[i])
