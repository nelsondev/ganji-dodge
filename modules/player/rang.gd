extends RigidBody3D

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(launch)
	
func launch():
	
	apply_central_force(Vector3.FORWARD * 100)
	
