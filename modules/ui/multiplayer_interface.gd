extends Node3D

@onready var xr_origin = $"../XROrigin3D"
@onready var xr_camera = xr_origin.get_node("XRCamera")
@onready var xr_marker = xr_camera.get_node("InterfaceMarker")
@onready var xr_hand = xr_origin.get_node("XRLeftHand")

var cursor_speed = 200
var cursor_velocity = Vector2.ZERO

func is_open(): return visible
func is_closed(): return not visible

func _ready() -> void:
	if not visible: return
	$SubViewport/CanvasLayer/Control/ScrollContainer/VBoxContainer/LocalhostButton.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("player_left"):
		var owner = $SubViewport.gui_get_focus_owner()
		owner.get_node(owner.focus_previous).grab_focus()
	if Input.is_action_just_pressed("player_right"):
		var owner = $SubViewport.gui_get_focus_owner()
		owner.get_node(owner.focus_next).grab_focus()

func _on_xr_left_hand_button_pressed(name: String) -> void:
	if visible:
		if name == "menu_button": _close()
		if name == "primary":
			pass
	else:
		if name == "menu_button": _open()
	
func _open():
	$AnimationPlayer.play("open")
	global_position = xr_marker.global_position
	look_at(xr_camera.global_position)
	
func _close():
	$AnimationPlayer.play("close")
