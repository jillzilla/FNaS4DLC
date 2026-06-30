class_name CharacterGuideButtonComponent extends Component

#variables
@export var character_name: String;
@export var button: TextureButton;
@export var description: RichTextLabel;

#functions
func _ready() -> void:
	button.connect("mouse_entered", _on_button_mouse_entered);

func _on_button_mouse_entered() -> void:
	description.text = character_name + ":\n" + main.guide_text[character_name];