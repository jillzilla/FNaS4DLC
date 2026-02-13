extends Node

#variables
@export var nightcounter : Label;

var sceneDestination : String;

#functions
func _ready() -> void:
	DiscordManager._update_details("Entering Night " + str(main.nightcounter));
	DiscordManager._update_state("");
	
	nightcounter.text = "Night " + str(main.nightcounter) + "\n12:00 AM";
	
	sceneDestination = "res://assets/scenes/gameplay.tscn";
	
	if main.nightcounter < 6:
		sceneDestination = "res://assets/scenes/tutorials.tscn";
		_set_ai_levels();
		
	main._update_ai_levels();
	
func _set_ai_levels() -> void:
	match(main.nightcounter):
		1:
			main.aiLevelsAsArrays[0] = 0;
			main.aiLevelsAsArrays[1] = 5;
			main.aiLevelsAsArrays[2] = 5;
			main.aiLevelsAsArrays[3] = 5;
			main.aiLevelsAsArrays[4] = 0;
			main.aiLevelsAsArrays[5] = 0;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 0;
		2:
			main.aiLevelsAsArrays[0] = 5;
			main.aiLevelsAsArrays[1] = 8;
			main.aiLevelsAsArrays[2] = 8;
			main.aiLevelsAsArrays[3] = 8;
			main.aiLevelsAsArrays[4] = 5;
			main.aiLevelsAsArrays[5] = 0;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 0;
		3:
			main.aiLevelsAsArrays[0] = 8;
			main.aiLevelsAsArrays[1] = 12;
			main.aiLevelsAsArrays[2] = 12;
			main.aiLevelsAsArrays[3] = 12;
			main.aiLevelsAsArrays[4] = 8;
			main.aiLevelsAsArrays[5] = 5;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 0;
		4:
			main.aiLevelsAsArrays[0] = 12;
			main.aiLevelsAsArrays[1] = 15;
			main.aiLevelsAsArrays[2] = 15;
			main.aiLevelsAsArrays[3] = 15;
			main.aiLevelsAsArrays[4] = 12;
			main.aiLevelsAsArrays[5] = 8;
			main.aiLevelsAsArrays[6] = 5;
			main.aiLevelsAsArrays[7] = 0;
		5:
			main.aiLevelsAsArrays[0] = 17;
			main.aiLevelsAsArrays[1] = 17;
			main.aiLevelsAsArrays[2] = 17;
			main.aiLevelsAsArrays[3] = 17;
			main.aiLevelsAsArrays[4] = 17;
			main.aiLevelsAsArrays[5] = 17;
			main.aiLevelsAsArrays[6] = 17;
			main.aiLevelsAsArrays[7] = 0;
		6:
			main.aiLevelsAsArrays[0] = 0;
			main.aiLevelsAsArrays[1] = 0;
			main.aiLevelsAsArrays[2] = 0;
			main.aiLevelsAsArrays[3] = 0;
			main.aiLevelsAsArrays[4] = 0;
			main.aiLevelsAsArrays[5] = 0;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 30;

func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		get_tree().change_scene_to_file(sceneDestination);
