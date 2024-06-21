@tool
extends MeshInstance3D

@export_category("Button")
@export var text = "BUTTON":
	set(value):
		text = value
		$SubViewport/Label.text = text
	get():
		return text
@export var background_color: Color = Color.WHITE:
	set(value):
		background_color = value
		$SubViewport/Label.get_theme_stylebox("normal").bg_color = background_color
	get():
		return background_color
@export var font_color: Color = Color.BLACK:
	set(value):
		font_color = value
		$SubViewport/Label.set("theme_override_colors/font_color", font_color)
	
