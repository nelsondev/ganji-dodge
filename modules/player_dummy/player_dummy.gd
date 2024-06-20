extends Node3D
class_name PlayerDummy

func syncronize(data: Dictionary):
	global_position = data["global_position"]
	
	var skeleton = $Mesh/RootNode/Skeleton3D as Skeleton3D
	var left_hand = $Mesh/RootNode/Skeleton3D.find_bone("CC_Base_L_Hand")
	var right_hand = $Mesh/RootNode/Skeleton3D.find_bone("CC_Base_R_Hand")
	
	var left_hand_upperarm = skeleton.find_bone("CC_Base_L_Upperarm")
	var right_hand_upperarm = skeleton.find_bone("CC_Base_R_Upperarm")
	
	var left_arm_trans = skeleton.get_bone_global_pose(left_hand_upperarm)
	var right_arm_trans = skeleton.get_bone_global_pose(right_hand_upperarm)
	
	var left_looking = left_arm_trans.looking_at(data["left_transform"])
	var right_looking = right_arm_trans.looking_at(data["right_transform"])
	
	skeleton.set_bone_global_pose(left_hand_upperarm, left_looking)
	skeleton.set_bone_global_pose(right_hand_upperarm, right_looking)
	skeleton.set_bone_global_pose(left_hand, data["left_transform"])
	skeleton.set_bone_global_pose(right_hand, data["right_transform"])
	
