class_name PlushCharacter extends Node

#variables
@export var char_name : String = "";
@export var timer_movement : Timer;
@export var timer_kill : Timer;
@export var sprites : Array[Sprite2D];
@export var steps : Array[AudioStreamPlayer];
@export var flashlight : FlashlightComponentMinigame;
@export var jumpscare : Node2D;
@export var time_left : Timer;

var movement_opportunity_rate : float;

#functions
func _ready() -> void:
	timer_movement.connect("timeout", _movement_timeout);
	timer_kill.connect("timeout", _kill_timeout);
	timer_movement.start();

func _movement_timeout() -> void:
	if main.PlayerAlive:
		if randf() * 100 <= movement_opportunity_rate:
			if flashlight.is_on:
				flashlight._turn_off();
			steps.pick_random().play();
			sprites.pick_random().show();
			timer_kill.start();
			print("walk walk walk")
		else:
			timer_movement.start();
	
func _kill_timeout() -> void:
	if main.PlayerAlive:
		for i in range(sprites.size()):
			if sprites[i].visible:
				sprites[i].hide();
		main.PlayerAlive = false;
		time_left.stop();
		if flashlight.is_on:
			flashlight._turn_off();
		flashlight.process_mode = Node.PROCESS_MODE_DISABLED;
		main.killedBy = char_name;
		GlobalAudioManager.get_node(char_name + "_Jumpscare").play();
		jumpscare.animation.play("jumpscare");
