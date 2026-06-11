extends Node

#variables
@export var nightcounter : Label;
var sceneDestination : String;

@onready var loading : Control = $Loading;

#functions
func _ready() -> void:
	if !main.play_minigame:
		DiscordManager._update_details("Entering Night " + str(main.nightcounter));
		DiscordManager._update_state("");
		
		nightcounter.text = "Night " + str(main.nightcounter) + "\n12:00 AM";
		
		sceneDestination = "res://assets/scenes/gameplay.tscn";
		
		if main.nightcounter < 7:
			_set_ai_levels();
		
		if main.nightcounter < 6:
			sceneDestination = "res://assets/scenes/tutorials.tscn";
			
		main._update_ai_levels();
	else:
		DiscordManager._update_details("Entering Mini-Game");
		DiscordManager._update_state("");
		
		nightcounter.text = "Fun With Plushnic & Plushtails";
		
		if !main.played_minigame_once:
			sceneDestination = "res://assets/scenes/tutorials.tscn";
		else:
			sceneDestination = "res://assets/scenes/minigame.tscn";
	
func _set_ai_levels() -> void:
	match(main.nightcounter):
		1:
			main.aiLevelsAsArrays[0] = 0;
			main.aiLevelsAsArrays[1] = 8;
			main.aiLevelsAsArrays[2] = 8;
			main.aiLevelsAsArrays[3] = 8;
			main.aiLevelsAsArrays[4] = 0;
			main.aiLevelsAsArrays[5] = 0;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 0;
			main.aiLevelsAsArrays[8] = 0;
			main.aiLevelsAsArrays[9] = 0;
		2:
			main.aiLevelsAsArrays[0] = 8;
			main.aiLevelsAsArrays[1] = 10;
			main.aiLevelsAsArrays[2] = 10;
			main.aiLevelsAsArrays[3] = 10;
			main.aiLevelsAsArrays[4] = 8;
			main.aiLevelsAsArrays[5] = 0;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 0;
			main.aiLevelsAsArrays[8] = 0;
			main.aiLevelsAsArrays[9] = 0;
		3:
			main.aiLevelsAsArrays[0] = 10;
			main.aiLevelsAsArrays[1] = 12;
			main.aiLevelsAsArrays[2] = 12;
			main.aiLevelsAsArrays[3] = 12;
			main.aiLevelsAsArrays[4] = 10;
			main.aiLevelsAsArrays[5] = 8;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 0;
			main.aiLevelsAsArrays[8] = 0;
			main.aiLevelsAsArrays[9] = 0;
		4:
			main.aiLevelsAsArrays[0] = 12;
			main.aiLevelsAsArrays[1] = 14;
			main.aiLevelsAsArrays[2] = 14;
			main.aiLevelsAsArrays[3] = 14;
			main.aiLevelsAsArrays[4] = 12;
			main.aiLevelsAsArrays[5] = 10;
			main.aiLevelsAsArrays[6] = 8;
			main.aiLevelsAsArrays[7] = 0;
			main.aiLevelsAsArrays[8] = 0;
			main.aiLevelsAsArrays[9] = 0;
		5:
			main.aiLevelsAsArrays[0] = 14;
			main.aiLevelsAsArrays[1] = 15;
			main.aiLevelsAsArrays[2] = 15;
			main.aiLevelsAsArrays[3] = 15;
			main.aiLevelsAsArrays[4] = 14;
			main.aiLevelsAsArrays[5] = 12;
			main.aiLevelsAsArrays[6] = 10;
			main.aiLevelsAsArrays[7] = 0;
			main.aiLevelsAsArrays[8] = 0;
			main.aiLevelsAsArrays[9] = 0;
		6:
			main.aiLevelsAsArrays[0] = 17;
			main.aiLevelsAsArrays[1] = 17;
			main.aiLevelsAsArrays[2] = 17;
			main.aiLevelsAsArrays[3] = 17;
			main.aiLevelsAsArrays[4] = 0;
			main.aiLevelsAsArrays[5] = 0;
			main.aiLevelsAsArrays[6] = 0;
			main.aiLevelsAsArrays[7] = 1;
			main.aiLevelsAsArrays[8] = 0;
			main.aiLevelsAsArrays[9] = 0;

func _on_timer_start_ambience_timeout() -> void:
	if !main.play_minigame:
		GlobalAudioManager.get_node("Ambience").play();
	else:
		GlobalAudioManager.get_node("Ambience_Minigame").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		if !main.didrarescreenhappened:
			if main.random_chance(95):
				loading._load_scene(sceneDestination);
				await loading.scene_loaded;
				get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
			else:
				loading._load_scene("res://assets/scenes/rare_screens.tscn");
				await loading.scene_loaded;
				get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
		else:
				loading._load_scene(sceneDestination);
				await loading.scene_loaded;
				get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
