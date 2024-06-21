extends CharacterBody3D
class_name Player

const SPEED = 4.5

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if input_dir.is_zero_approx():
		input_dir = $XROrigin3D/XRLeftHand.get_vector2("primary")
		input_dir.y *= -1
	
	var direction = ($XROrigin3D/XRCamera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	direction.y = 0
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
