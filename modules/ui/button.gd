@tool
extends MeshInstance3D

signal click

@export_category("Button")
@export var text = "BUTTON":
	set(value):
		text = value
		$SubViewport/Label.text = text
	get():
		return text
@export var font_color: Color = Color.BLACK:
	set(value):
		font_color = value
		$SubViewport/Label.set("theme_override_colors/font_color", font_color)
@export var stylebox: StyleBox = StyleBoxFlat.new():
	set(value):
		$SubViewport/Label.set("theme_override_styles/normal", value)
	get():
		return $SubViewport/Label.get("theme_override_styles/normal")
