extends Node

@onready var loading : Control = $Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Extras");
	DiscordManager._update_state("");

func _on_back_pressed() -> void:
	loading._load_scene("res://assets/scenes/title.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
