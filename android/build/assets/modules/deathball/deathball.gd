extends RigidBody3D
class_name DeathBall

@onready var target = $"../Players/FakePlayer"
@onready var scalar = 1.0

func _physics_process(delta):
	apply_central_force(global_position.direction_to(target.global_position) * 0.1 * scalar)

func switch_targets():
	if target == $"../Players/FakePlayer":
		target = $"../Players/FakePlayer2"
	else:
		target = $"../Players/FakePlayer"
	linear_velocity = Vector3.ZERO
	apply_central_force(global_position.direction_to(target.global_position) * 10 * scalar)
	scalar *= 1.1
