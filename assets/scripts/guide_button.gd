extends TextureButton

@export var label : RichTextLabel;
@export var text : String;

func _ready() -> void:
	connect("mouse_entered", _mouse_entered);

func _mouse_entered() -> void:
	label.text = text;
