class_name CharacterGuideButtonComponent extends Component

#variables
@export_file_path("*.json") var data_json : String = "";
@export var character_name : String;

@export var button : TextureButton;
@export var description : RichTextLabel;

var data : Dictionary = {};

#functions
func _ready() -> void:
	var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
	var json_text: String = file.get_as_text();
	file.close();
	data = JSON.parse_string(json_text);
	button.connect("mouse_entered", _on_button_mouse_entered);

func _on_button_mouse_entered() -> void:
	description.text = character_name + ":\n" + data[character_name];