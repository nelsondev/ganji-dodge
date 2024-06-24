extends Node3D
class_name PlayerDummy

var global_position_to: Vector3
var global_position_left_hand_to: Vector3
var global_position_right_hand_to: Vector3
var global_rotation_left_hand_to: Vector3
var global_rotation_right_hand_to: Vector3

#@onready var left_constraint = $Ozzy/LeftHandConstraint
#@onready var right_constraint = $Ozzy/RightHandConstraint

#func _ready() -> void:
	#$Ozzy/Skeleton3D/SkeletonIK3DLeftHand.start()
	#$Ozzy/Skeleton3D/SkeletonIK3DRightHand.start()

func syncronize(data: Dictionary) -> void:
	if not data: return
	
	global_position_to = data["global_position"]
	global_position_left_hand_to = data["left_controller"]["pos"]
	global_position_right_hand_to = data["right_controller"]["pos"]
	global_rotation_left_hand_to = data["left_controller"]["rot"]
	global_rotation_right_hand_to = data["right_controller"]["rot"]
	
func _process(delta: float) -> void:
	global_position = global_position.lerp(global_position_to, 0.5)
	#left_constraint.global_position = left_constraint.global_position.lerp(global_position_left_hand_to, 0.5)
	#right_constraint.global_position = right_constraint.global_position.lerp(global_position_right_hand_to, 0.5)
	#left_constraint.global_rotation = left_constraint.global_rotation.lerp(global_rotation_left_hand_to, 0.5)
	#right_constraint.global_rotation = right_constraint.global_rotation.lerp(global_rotation_right_hand_to, 0.5)
