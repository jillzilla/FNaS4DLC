extends Node

#variables
@onready var counter: Label = $UI/Counter;
@onready var loading: Control = $Loading;
@onready var desc: RichTextLabel = $UI/Description;

#functions
func _ready() -> void:
	DiscordManager._update_state("Reading The Tutorial...");
	counter.text = "TUTORIAL " + "(Night " + str(main.nightcounter) + ")";
	
	if main.nightcounter > 0 && main.nightcounter < 6:
		desc.text = main.tutorials_text[main.nightcounter];

func _on_button_pressed() -> void:
	loading._load_scene("uid://dj4ueyd0v0uvy");