extends TextureButton

#variables
@export var text: String;
@export var label: RichTextLabel;

#functions
func _ready() -> void:
	connect("mouse_entered", _mouse_entered);

func _mouse_entered() -> void:
	label.text = text;