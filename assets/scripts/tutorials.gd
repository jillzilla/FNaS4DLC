extends Node

#variables
@export var night : Label;
@onready var loading : Control = $Loading;

#functions
func _ready() -> void:
	DiscordManager._update_state("Reading The Tutorial...");
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

func _on_button_pressed() -> void:
	loading._load_scene("res://assets/scenes/gameplay.tscn");
