extends Node

#variables
@onready var loading : Control = $Loading;
@onready var golden : Sprite2D = $Golden;
@onready var luigi : Sprite2D = $Luigi;

@export var goldeneyes : CompressedTexture2D = null;
@export var luigieyes : CompressedTexture2D = null;

#functions
func _ready() -> void:
	DiscordManager._update_details("Rare Screen");
	DiscordManager._update_state("");
	GlobalAudioManager.get_node("Ambience").stop();
	var chars : Array[Sprite2D] = [golden,luigi];
	chars.pick_random().visible = true;
	main.didrarescreenhappened = true;

func _on_sound_finished() -> void:
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_timer_timeout() -> void:
	golden.texture = goldeneyes;
	luigi.texture = luigieyes;
