extends Node

@rpc("authority", "unreliable", "call_local")
func _sync(players): pass
@rpc("any_peer", "reliable", "call_remote")
func _voip(data, buffer_size): pass
