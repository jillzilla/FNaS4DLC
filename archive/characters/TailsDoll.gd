class_name TailsDoll extends Node

#variables
enum Directions {NONE, LEFT, RIGHT, CEILING};
var Direction: Variant = Directions.NONE;
var positionsAvailable: int = 1;

@export_group("Status")
@export var currentPosition: int = 0;
@export var movement_opportunity_timer: Timer;

@export_group("Sprites")
@export var position_left: Sprite2D;
@export var position_right: Sprite2D;
@export var position_up: Sprite2D;
@export var eyes_left: Sprite2D;
@export var eyes_right: Sprite2D;
@export var eyes_up: Sprite2D;

@export_group("Mechanicals")
@export var effect: AnimationPlayer;
@export var LFlashlight: FlashLightComponent;
@export var RFlashlight: FlashLightComponent;
@export var CFlashlight: FlashLightComponent;

var fails: int = 0;

#functions
func _ready() -> void:
	movement_opportunity_timer.connect("timeout", _movement_opportunity_timeout);
	_handle_positions();
	
func _process(_delta: float) -> void:
	eyes_left.modulate.a = position_left.modulate.a;
	eyes_right.modulate.a = position_right.modulate.a;
	eyes_up.modulate.a = position_up.modulate.a;
	
	if !main.PlayerAlive:
		if effect.get_parent().visible:
			effect.get_parent().hide();
	
func _movement_opportunity_timeout() -> void:
	if main.PlayerAlive:
		if main.TailsDollAiLevel >= main.AIMAXVALUE && randf() * main.AIMAXVALUE + 5 <= main.TailsDollAiLevel || main.TailsDollAiLevel < main.AIMAXVALUE && randf() * main.AIMAXVALUE <= main.TailsDollAiLevel || fails >= 3:
			fails = 0;
			_switch_path();
			currentPosition += 1;
			_handle_positions();
		else:
			fails += 1;
			movement_opportunity_timer.start();
		
func _switch_path() -> void:
	var path: int = randi_range(1, 3);
	match (path):
		1:
			Direction = Directions.LEFT;
		2:
			Direction = Directions.RIGHT;
		3:
			Direction = Directions.CEILING;

func _handle_positions() -> void:
	if currentPosition == 1:
		match (Direction):
			Directions.LEFT:
				if LFlashlight.is_on:
					LFlashlight._turn_off();
			Directions.RIGHT:
				if RFlashlight.is_on:
					RFlashlight._turn_off();
			Directions.CEILING:
				if CFlashlight.is_on:
					CFlashlight._turn_off();
	match (currentPosition):
		0:
			if main.TailsDollAiLevel != 0:
				movement_opportunity_timer.start();
			
			position_left.visible = false;
			position_right.visible = false;
			position_up.visible = false;
			
			eyes_left.visible = false;
			eyes_right.visible = false;
			eyes_up.visible = false;
		1:
			match (Direction):
				Directions.LEFT:
					position_left.visible = true;
					eyes_left.visible = true;
				Directions.RIGHT:
					position_right.visible = true;
					eyes_right.visible = true;
				Directions.CEILING:
					position_up.visible = true;
					eyes_up.visible = true;
			effect.speed_scale = 0.05;
			effect.play("ATTACK");
