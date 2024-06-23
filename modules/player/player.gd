extends XROrigin3D
class_name Player

func _on_interface_opened() -> void:
	$XRLeftHand/MovementDirect.enabled = false

func _on_interface_closed() -> void:
	$XRLeftHand/MovementDirect.enabled = true
