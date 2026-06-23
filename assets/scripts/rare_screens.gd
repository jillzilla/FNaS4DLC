extends Node

#variables
@export_file_path("*.png") var goldeneyes: String = "";
@export_file_path("*.png") var luigieyes: String = "";

@onready var loading: Control = $Loading;
@onready var golden: Sprite2D = $Golden;
@onready var luigi: Sprite2D = $Luigi;

#functions
func _ready() -> void:
	DiscordManager._update_details("???");
	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();

	var chars: Array[Sprite2D] = [golden, luigi];
	chars.pick_random().show();
	
	main.didrarescreenhappened = true;

func _on_sound_finished() -> void:
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_timer_timeout() -> void:
	golden.texture = load(goldeneyes);
	luigi.texture = load(luigieyes);