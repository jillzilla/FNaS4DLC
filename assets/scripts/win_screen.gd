extends Node

#variables
@export var clockanimation : AnimationPlayer;
var nextscene : String;

#functions
func _ready() -> void:
	DiscordManager._update_details("Win Screen");
	DiscordManager._update_state("Night " + str(main.nightcounter));
	
	GlobalAudioManager.get_node("Ambience").stop();
	
	if main.nightcounter < 5:
		nextscene = "res://assets/scenes/night_screen.tscn";
		
	elif main.nightcounter == 5:
		if !main.night5ending:
			main.night5ending = true;
		nextscene = "res://assets/scenes/night_5_ending.tscn";
		
	elif main.nightcounter == 6:
		if !main.night6ending:
			main.night6ending = true;
		nextscene = "res://assets/scenes/night_6_ending.tscn";
		
	elif main.nightcounter == 7:
		if !main.night7ending:
			main.night7ending = true;
		nextscene = "res://assets/scenes/title.tscn";
		
	if main.nightcounter < 5:
		main.nightcounter += 1;
		
	main._reset_ai();
	main._save_game();

func _on_timer_timeout() -> void:
	clockanimation.play("lowtaperfade");

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "win":
		get_tree().change_scene_to_file(nextscene);
