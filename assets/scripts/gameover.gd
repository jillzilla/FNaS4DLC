extends Node

#variables
@export_file_path("*.json") var data_json: String = "";

@onready var loading: Control = $Loading;
@onready var ui: Control = $Control;

@onready var tryagain: Button = $Control/TryAgainButton;
@onready var menubutton: Button = $Control/MenuButton;

@onready var fadeanimation: AnimationPlayer = $Fade/AnimationPlayer;

@onready var static_: AnimatedSprite2D = $Static;

var data: Dictionary = {};

#functions
func _ready() -> void:
	DiscordManager._update_details("Game Over Screen");
	DiscordManager._update_state("Killed by " + main.killedBy);

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
	var json_text: String = file.get_as_text();
	file.close();
	data = JSON.parse_string(json_text);
	
	if main.killedBy != "":
		get_node(data[main.killedBy]["Character Path"]).show();
		get_node(data[main.killedBy]["Overlay"]).show();

func _on_try_again_button_pressed() -> void:
	tryagain.visible = false;
	menubutton.visible = false;
	fadeanimation.play("fade");
	await fadeanimation.animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_menu_button_pressed() -> void:
	tryagain.visible = false;
	menubutton.visible = false;
	fadeanimation.play("fade");
	await fadeanimation.animation_finished;
	loading._load_scene("res://assets/scenes/title.tscn");
	
func _on_timer_timeout() -> void:
	ui.show();
	static_.modulate.a = 0.5;