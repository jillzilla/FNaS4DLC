extends Node

@onready var loading : Control = $Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Intro Screen");
	DiscordManager._update_state("");

func _on_button_pressed() -> void:
	if main.introscenewatched:
		loading._load_scene("res://assets/scenes/title.tscn");
		await loading.scene_loaded;
		get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
		#get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
	else:
		loading._load_scene("res://assets/scenes/introcutscene.tscn");
		await loading.scene_loaded;
		get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
		#get_tree().change_scene_to_file("res://assets/scenes/introcutscene.tscn");
