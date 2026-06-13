extends Node

#variables
@onready var loading : Control = $Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Intro Screen");
	DiscordManager._update_state("");

func _on_button_pressed() -> void:
	if main.introscenewatched:
		loading._load_scene("res://assets/scenes/title.tscn");
	else:
		loading._load_scene("res://assets/scenes/introcutscene.tscn");
