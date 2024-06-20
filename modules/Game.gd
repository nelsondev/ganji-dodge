extends Node

func _ready() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print("No VR interface found.")

func get_game_node(path: NodePath): return get_tree().root.get_node("Node3D").get_node(path)
func get_player(): return get_game_node("Player") as Player
func get_player_node(path: NodePath): return get_player().get_node(path)
func get_players(): return get_game_node("Players") as Node3D
func get_dummy(path: NodePath): return get_players().get_node(path) as PlayerDummy
func get_left_controller(): return get_player_node("XROrigin3D/XRLeftHand") as XRController3D
func get_right_controller(): return get_player_node("XROrigin3D/XRRightHand") as XRController3D
