extends Node

#variables
@onready var loading : Control = $Loading;
@onready var ui : Control = $Control;
@onready var tryagain : Button = $Control/TryAgainButton;
@onready var menubutton : Button = $Control/MenuButton;
@onready var fadeanimation : AnimationPlayer = $Fade/AnimationPlayer;
@onready var static_ : AnimatedSprite2D = $Static;

#functions
func _ready() -> void:
	DiscordManager._update_details("Game Over Screen");
	DiscordManager._update_state("Killed by " + main.killedBy);
	_handle_gameover_art();

func _on_try_again_button_pressed() -> void:
	tryagain.visible = false;
	menubutton.visible = false;
	fadeanimation.play("fade");
	await fadeanimation.animation_finished;
	loading._load_scene("res://assets/scenes/night_screen.tscn");

func _on_menu_button_pressed() -> void:
	main._reset_ai();
	tryagain.visible = false;
	menubutton.visible = false;
	fadeanimation.play("fade");
	await fadeanimation.animation_finished;
	loading._load_scene("res://assets/scenes/title.tscn");
	
func _on_timer_timeout() -> void:
	ui.visible = true;
	static_.modulate.a = 0.5;

func _handle_gameover_art() -> void:
	match(main.killedBy):
		"Nightmare Taingle":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/Taingle").visible = true;
		"Nightmare Toy Yoshi":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/ToyYoshi").visible = true;
		"Nightmare Toy Sonic":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/ToySonic").visible = true;
		"Nightmare Toy Mario":
			get_node("Overlays/Mask").visible = true;
			get_node("Characters/ToyMario").visible = true;
		"Nightmare Salvage Sonic":
			get_node("AmyDeath").visible = true;
			get_node("Characters/Salvage").visible = true;
		"Nightmare Cream":
			get_node("AmyDeath").visible = true;
			get_node("Characters/Cream").visible = true;
		"Nightmare Luiginette":
			get_node("Overlays/POV").visible = true;
			get_node("Characters/Luigi").visible = true;
		"Nightmare Knuckles":
			get_node("AmyDeath").visible = true;
			get_node("Characters/Knuckles").visible = true;
