extends Node

#variables
@export var nightcounter : Label;

#functions
func _ready() -> void:
	DiscordManager._update_details("Entering Night " + str(main.nightcounter));
	DiscordManager._update_state("");
	
	nightcounter.text = "Night " + str(main.nightcounter) + "\n12:00 AM";

func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");
