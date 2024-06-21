extends Node3D
class_name PlayerDummy

func syncronize(data: Dictionary):
	global_position = data["global_position"]
	print(data)
	var skeleton = $Mesh/RootNode/Skeleton3D as Skeleton3D
	var left_hand = $Mesh/RootNode/Skeleton3D.find_bone("CC_Base_L_Hand")
	var right_hand = $Mesh/RootNode/Skeleton3D.find_bone("CC_Base_R_Hand")
	
	skeleton.set_bone_global_pose(left_hand, data["left_transform"])
	skeleton.set_bone_global_pose(right_hand, data["right_transform"])
	
