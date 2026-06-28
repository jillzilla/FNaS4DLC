extends Node

#variables
@onready var loading: Control = $Loading;

@onready var luigi: AnimatedSprite2D = $Luigi;
@onready var golden: AnimatedSprite2D = $Golden;

@onready var selected_character: AnimatedSprite2D = null;

#functions
func _ready() -> void:
	DiscordManager._update_details("???");
	DiscordManager._update_state("");

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();

	var chars: Array[AnimatedSprite2D] = [golden, luigi];
	selected_character = chars.pick_random();
	selected_character.show();
	
	main.didrarescreenhappened = true;

func _on_sound_finished() -> void:
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_timer_timeout() -> void:
	selected_character.play("open_eyes");