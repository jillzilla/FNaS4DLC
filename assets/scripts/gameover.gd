extends Node

#variables
@onready var loading: Control = $Loading;
@onready var ui: Control = $Control;

@onready var tryagain: Button = $Control/TryAgainButton;
@onready var menubutton: Button = $Control/MenuButton;

@onready var fadeanimation: AnimationPlayer = $Fade/AnimationPlayer;

@onready var static_: AnimatedSprite2D = $Static;

#functions
func _ready() -> void:
	DiscordManager._update_details("Game Over...");
	DiscordManager._update_state("Killed by " + main.killedBy);

	if GlobalAudioManager.get_node("Ambience").is_playing():
		GlobalAudioManager.get_node("Ambience").stop();
	
	if main.killedBy != "":
		get_node(main.game_over_graphics[main.killedBy]["Character Path"]).show();
		get_node(main.game_over_graphics[main.killedBy]["Overlay"]).show();
	
	main.killedBy = "";

func _on_try_again_button_pressed() -> void:
	tryagain.hide();
	menubutton.hide();
	fadeanimation.play("fade");
	await fadeanimation.animation_finished;
	loading._load_scene("uid://bocmtkamvkla5");

func _on_menu_button_pressed() -> void:
	tryagain.hide();
	menubutton.hide();
	fadeanimation.play("fade");
	await fadeanimation.animation_finished;
	loading._load_scene("uid://cl7jf3xdjegaf");
	
func _on_timer_timeout() -> void:
	ui.show();
	static_.modulate.a = 0.5;