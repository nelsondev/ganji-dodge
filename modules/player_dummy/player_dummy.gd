extends Node3D
class_name PlayerDummy

func syncronize(data: Dictionary):
	global_position = data["global_position"]
