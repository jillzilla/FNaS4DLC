extends Node

#variables
@export_file_path("*.json") var data_json: String = "";

@onready var loading: Control = $Loading;

@onready var nightcounter: Label = $NightCounter;

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

var data: Dictionary = {};

#functions
func _ready() -> void:
	DiscordManager._update_details("Entering Night " + str(main.nightcounter));
	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	nightcounter.text = "Night " + str(main.nightcounter) + "\n" + "12:00 AM";
	
	main.killedBy = "";
	main.isBTInOffice = false;

	var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
	var json_text: String = file.get_as_text();
	file.close();
	data = JSON.parse_string(json_text);
	
	if main.nightcounter > 0 && main.nightcounter < 7:
		for i in range(main._get_ai_level_as_array().size()):
			main.ai_levels[main._get_ai_level_as_array()[i]] = data["Night " + str(main.nightcounter)][main._get_ai_level_as_array()[i]];
	
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
