extends Node

var BUFFER = 1024

@onready var bus_index = AudioServer.get_bus_index("Voice")
@onready var effect = AudioServer.get_bus_effect(bus_index, 4) as AudioEffectCapture

func add_voip():
	var player = AudioStreamPlayer.new()
	player.stream = AudioStreamMicrophone.new()
	player.bus = "Voice"
	add_child(player)
	player.play()
	
func remove_voip():
	var player = get_child(0)
	player.queue_free()

func has_voip(): 
	return get_child_count() > 0

func _physics_process(delta: float) -> void:
	if not multiplayer.has_multiplayer_peer(): return
	if not has_voip(): return
	BUFFER = effect.get_frames_available()
	if effect.can_get_buffer(BUFFER):
		Client._voip.rpc(effect.get_buffer(BUFFER), BUFFER)
	effect.clear_buffer()
