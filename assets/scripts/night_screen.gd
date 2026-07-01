extends Node

#variables
@onready var loading: Control = $Loading;
@onready var nightcounter: Label = $NightCounter;
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

#functions
func _ready() -> void:
	if main.nightcounter != 7:
		DiscordManager._update_details("Entering Night " + str(main.nightcounter));
	else:
		DiscordManager._update_details("Entering Custom Night");

	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	if main.nightcounter != 7:
		nightcounter.text = "Night " + str(main.nightcounter) + "\n" + "12:00 AM";
	else:
		nightcounter.text = "Custom Night" + "\n" + "12:00 AM";
	
	if main.nightcounter > 0 && main.nightcounter < 7:
		for i in range(main._get_ai_level_as_array().size()):
			main.ai_levels[main._get_ai_level_as_array()[i]] = main.ai_nights[main.nightcounter][main._get_ai_level_as_array()[i]];
	
	print(main.ai_levels);

func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		rng.randomize();
		if rng.randf() <= 0.1 && !main.didrarescreenhappened:
			loading._load_scene("res://assets/scenes/rare_screens.tscn");
		else:
			main.didrarescreenhappened = false;
			if main.nightcounter > 0 && main.nightcounter < 6:
				loading._load_scene("res://assets/scenes/tutorials.tscn");
			else:
				loading._load_scene("res://assets/scenes/gameplay.tscn");