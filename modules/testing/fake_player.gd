extends Area3D

func _ready():
	body_entered.connect(_body_entered)
	

func _body_entered(body):
	if not body is DeathBall: return
	body.switch_targets()
