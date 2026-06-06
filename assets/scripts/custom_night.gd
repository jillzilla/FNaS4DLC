extends Node

@onready var loading : Control = $Loading;

#variables
@export var characters : Array[VBoxContainer];

#functions
func _ready() -> void:
	DiscordManager._update_details("Custom Night Menu");
	DiscordManager._update_state("");

func _on_back_pressed() -> void:
	loading._load_scene("res://assets/scenes/title.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_ready_pressed() -> void:
	main.nightcounter = 7;
	loading._load_scene("res://assets/scenes/night_screen.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_min_pressed() -> void:
	for i in range(characters.size()):
		characters[i]._set_min();

func _on_max_pressed() -> void:
	for i in range(characters.size()):
		characters[i]._set_max();

func _on_random_pressed() -> void:
	for i in range(characters.size()):
		characters[i]._set_random();
