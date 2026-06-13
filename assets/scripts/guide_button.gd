extends TextureButton

#variables
@export var label: RichTextLabel;
@export var text: String;

#functions
func _ready() -> void:
	connect("mouse_entered", _mouse_entered);

func _mouse_entered() -> void:
	label.text = text;
