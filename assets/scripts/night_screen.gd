extends Node

#variables
@onready var loading: Control = $Loading;
@onready var nightcounter: Label = $NightCounter;
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

#functions
func _ready() -> void:
	match (main.nightcounter):
		main.CUSTOMNIGHTID:
			DiscordManager._update_details("Entering Custom Night");
			nightcounter.text = "Custom Night" + "\n" + "12:00 AM";
		main.ENDLESSID:
			DiscordManager._update_details("Entering Endless Mode");
			nightcounter.text = "Endless Mode";
			main._set_min_ai();
		_:
			DiscordManager._update_details("Entering Night " + str(main.nightcounter));
			nightcounter.text = "Night " + str(main.nightcounter) + "\n" + "12:00 AM";

	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	if main.nightcounter >= 1 && main.nightcounter <= 6:
		for i in range(main._get_ai_level_as_array().size()):
			main.ai_levels[main._get_ai_level_as_array()[i]] = main.ai_nights[main.nightcounter][main._get_ai_level_as_array()[i]];
	
	print(main.ai_levels);

func _on_timer_start_ambience_timeout() -> void:
	GlobalAudioManager.get_node("Ambience").play();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flash":
		rng.randomize();
		if rng.randf() <= 0.1 && !main.didrarescreenhappened:
			loading._load_scene("uid://ctb27mcbrbxlr");
		else:
			main.didrarescreenhappened = false;
			if main.nightcounter >= 1 && main.nightcounter <= 5:
				loading._load_scene("uid://buctj8g01lbef");
			else:
				loading._load_scene("uid://dj4ueyd0v0uvy");