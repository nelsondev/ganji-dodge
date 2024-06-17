extends CanvasLayer

func _ready():
	var rightController = Game.get_right_controller() as XRController3D
	
	rightController.button_pressed.connect(_pressed)
	
var i = 0
	
func _pressed(button):
	if i == 0:
		i = 1
		$Button.grab_click_focus()
		print("test")
	else:
		i = 0
		$TextEdit.grab_click_focus()
		print("test2")
