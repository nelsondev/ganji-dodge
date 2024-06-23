extends Node3D

signal opened
signal closed

@onready var xr_origin = $"../" as XROrigin3D
@onready var xr_camera = xr_origin.get_node("XRCamera") as XRCamera3D
@onready var xr_marker = xr_camera.get_node("InterfaceMarker")
@onready var xr_hand = xr_origin.get_node("XRLeftHand") as XRController3D

var loading = false

@onready var notes = [
	preload("res://modules/ui/sound_navigate_1.mp3"),
	preload("res://modules/ui/sound_navigate_2.mp3"),
	preload("res://modules/ui/sound_navigate_3.mp3")
]
@onready var notes_idx = 0
@onready var navigated = false

func is_open(): return visible
func is_closed(): return not visible

func _ready() -> void:
	visible = false
	$SubViewport/CanvasLayer/Control/ScrollContainer/VBoxContainer/LocalhostButton.grab_focus()

func _process(delta: float) -> void:
	_navigate()
	$UiLoading.visible = loading
	$UiFailed.visible = Client.failed

func _on_xr_left_hand_button_pressed(name: String) -> void:
	if visible:
		if name == "menu_button": _close()
	else:
		if name == "menu_button": _open()
		

func _on_xr_right_hand_button_pressed(name: String) -> void:
	if visible:
		if name == "ax_button": _connect()
		if name == "by_button": _disconnect()
		
func _open():
	if loading: return
	$AnimationPlayer2.play("open")
	global_position = xr_marker.global_position
	look_at(xr_camera.global_position)
	notes_idx = 0
	var tween = create_tween()
	tween.tween_property($Music, "volume_db", -20, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	opened.emit()
	
func _close():
	if loading: return
	$AnimationPlayer2.play("close")
	var tween = create_tween()
	tween.tween_property($Music, "volume_db", -80, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	closed.emit()

func _connect():
	if loading: return
	loading = true
	$ClickSound.play()
	var owner = $SubViewport.gui_get_focus_owner() as Button
	owner.button_pressed = true
	Client._connect(owner.text)
	await Client.connected
	loading = false
	_close()
	
func _disconnect():
	if loading: return
	loading = true
	$ClickSound.play()
	var owner = $SubViewport.gui_get_focus_owner() as Button
	owner.button_pressed = true
	Client._disconnect()
	await Client.disconnected
	loading = false
	_close()

func _navigate():
	if not visible or loading: return
	if navigated and xr_hand.get_vector2("primary").y == 0: navigated = false
	if Input.is_action_just_pressed("player_up") or (not navigated and xr_hand.get_vector2("primary").y < 0):
		var owner = $SubViewport.gui_get_focus_owner()
		owner.get_node(owner.focus_previous).grab_focus()
		$NavigateSound.stream = notes[notes_idx]
		$NavigateSound.play()
		notes_idx += 1 if notes_idx < 2 else -2
		navigated = true
	if Input.is_action_just_pressed("player_down") or (not navigated and xr_hand.get_vector2("primary").y > 0):
		var owner = $SubViewport.gui_get_focus_owner()
		owner.get_node(owner.focus_next).grab_focus()
		$NavigateSound.stream = notes[notes_idx]
		$NavigateSound.play()
		notes_idx += 1 if notes_idx < 2 else -2
		navigated = true
