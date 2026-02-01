extends Node

#variables
@export var dialoguemanager : Control;
@export var animation : AnimationPlayer;

#functions
func _ready() -> void:
	DiscordManager._update_details("Night 5 Ending");
	DiscordManager._update_state("");
	
	dialoguemanager.get_node("Dialogues/Night5Ending")._begin_dialogue();
	await dialoguemanager.get_node("Dialogues/Night5Ending").dialogueFinished;
	animation.play("motion");

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/title.tscn");
