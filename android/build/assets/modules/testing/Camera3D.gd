extends Camera3D

func _process(delta):
	look_at($"../Game/Deathball".global_position)
