extends Node

@onready var loading : Control = $Loading;
@onready var golden : Sprite2D = $Golden;
@onready var luigi : Sprite2D = $Luigi;

@export var goldeneyes : CompressedTexture2D = null;
@export var luigieyes : CompressedTexture2D = null;

func _ready() -> void:
	main.didrarescreenhappened = true;
	
	DiscordManager._update_details("Rare Screen");
	DiscordManager._update_state("");
	
	GlobalAudioManager.get_node("Ambience").stop();
	GlobalAudioManager.get_node("Ambience_Minigame").stop();
	
	var chars : Array[Sprite2D] = [golden,luigi];
	chars.pick_random().visible = true;

func _on_sound_finished() -> void:
	loading._load_scene("res://assets/scenes/night_screen.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);

func _on_timer_timeout() -> void:
	golden.texture = goldeneyes;
	luigi.texture = luigieyes;
