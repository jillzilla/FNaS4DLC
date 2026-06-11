extends Node

@onready var loading : Control = $Loading;

#variables
@export var night : Label;

#functions
func _ready() -> void:
	DiscordManager._update_state("Reading The Tutorial...");
	
	if !main.play_minigame:
		night.text = "TUTORIAL " + "(Night " + str(main.nightcounter) + ")";
		match(main.nightcounter):
			1:
				get_node("GUIWorld/Text").visible = true;
			2:
				get_node("GUIWorld/Text2").visible = true;
			3:
				get_node("GUIWorld/Text3").visible = true;
			4:
				get_node("GUIWorld/Text4").visible = true;
			5:
				get_node("GUIWorld/Text5").visible = true;
	else:
		night.text = "TUTORIAL MINI-GAME";
		if !main.played_minigame_once:
			main.played_minigame_once = true;
			main._save_game();
		get_node("GUIWorld/Text6").visible = true;

func _on_button_pressed() -> void:
	if !main.play_minigame:
		loading._load_scene("res://assets/scenes/gameplay.tscn");
	else:
		loading._load_scene("res://assets/scenes/minigame.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
