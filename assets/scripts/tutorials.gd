extends Node

#variables
@export_file_path("*.json") var data_json: String = "";

@onready var counter: Label = $UI/Counter;

@onready var loading: Control = $Loading;

@onready var desc: RichTextLabel = $UI/Description;

var data: Dictionary = {};

#functions
func _ready() -> void:
	DiscordManager._update_state("Reading The Tutorial...");
	counter.text = "TUTORIAL " + "(Night " + str(main.nightcounter) + ")";
	
	var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
	var json_text: String = file.get_as_text();
	file.close();
	data = JSON.parse_string(json_text);
	
	if main.nightcounter > 0 && main.nightcounter < 6:
		desc.text = data[str(main.nightcounter)];

func _on_button_pressed() -> void:
	loading._load_scene("res://assets/scenes/gameplay.tscn");