extends Node

#variables
@onready var loading: Control = $Loading;
@export var clockanimation: AnimationPlayer;
var next_scene_path : String = "";

#functions
func _ready() -> void:
	DiscordManager._update_details("Win Screen");
	DiscordManager._update_state("Night " + str(main.nightcounter));
	
	match (main.nightcounter):
		5:
			main.night5ending = true;
		6:
			main.night6ending = true;
		7:
			main.night7ending = true;

	next_scene_path = _get_next_scene();
	
	if !main.night5ending:
		main.night_to_play += 1;
		if main.nightcounter != main.night_to_play:
			main.nightcounter = main.night_to_play;
			
	main._save_game();

func _on_timer_timeout() -> void:
	clockanimation.play("lowtaperfade");

func _get_next_scene() -> String:
	if main.nightcounter < 5 && main.night5ending || main.nightcounter == 7:
		return "res://assets/scenes/title.tscn";
	elif main.nightcounter == 5:
		return"res://assets/scenes/night_5_ending.tscn";
	elif main.nightcounter == 6:
		return"res://assets/scenes/night_6_ending.tscn";
	else:
		return"res://assets/scenes/night_screen.tscn";

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "win":
		loading._load_scene(next_scene_path);