class_name NightmareLuiginetteV2 extends Node

#variables
enum directions {LEFT, MIDDLE, RIGHT};
enum attack_positions {NONE, LEFT_VENT, RIGHT_VENT, CEILING, HALLWAY};

var direction: Variant = directions.MIDDLE;
var attack_position: Variant = attack_positions.NONE;

@export var movement_opportunity_timer: Timer;

@export var walk_left: AudioStreamPlayer2D;
@export var walk_right: AudioStreamPlayer2D;
@export var walk_middle: AudioStreamPlayer2D;

@export var laughs: Array[AudioStreamPlayer];

@export var left_vent: AudioStreamPlayer2D;
@export var right_vent: AudioStreamPlayer2D;

@export var jump_sound: AudioStreamPlayer;
@export var get_close_sound: Array[AudioStreamPlayer];

@export var left_sprite: Sprite2D;
@export var right_sprite: Sprite2D;
@export var front_sprite: Sprite2D;
@export var up_sprite: Sprite2D;

@export var flashlight_left: FlashLightComponent;
@export var flashlight_right: FlashLightComponent;
@export var flashlight_up: FlashLightComponent;
@export var flashlight_front: FlashLightComponent;

var fails: int = 0;
var has_decided_his_path: bool = false;
 
func _ready() -> void:
	movement_opportunity_timer.connect("timeout", _movement_opportunity_timeout);
	
	if main.NightmareLuiginetteAiLevel != main.AIMINVALUE:
		movement_opportunity_timer.start();
	
func _movement_opportunity_timeout() -> void:
	if main.PlayerAlive:
		if !has_decided_his_path:
			match (direction):
				directions.MIDDLE:
					var possible_directions: Array[Variant] = [directions.LEFT, directions.RIGHT];
					direction = possible_directions.pick_random();
					if direction == directions.LEFT:
						walk_left.play();
					else:
						walk_right.play();
				directions.LEFT:
					var possible_direction = directions.MIDDLE;
					direction = possible_direction;
					walk_middle.play();
				directions.RIGHT:
					var possible_direction = directions.MIDDLE;
					direction = possible_direction;
					walk_middle.play();
			if fails < 3:
				if main.random_chance(60):
					fails = 0;
					has_decided_his_path = true;
				else:
					fails += 1;
			elif fails >= 3:
				fails = 0;
				has_decided_his_path = true;
			movement_opportunity_timer.start();
		else:
			laughs.pick_random().play();
			match (direction):
				directions.LEFT:
					var possible_attack_position: Variant = attack_positions.LEFT_VENT;
					attack_position = possible_attack_position;
					if flashlight_left.is_on:
						flashlight_left._turn_off();
					left_sprite.show();
					left_vent.play();
				directions.MIDDLE:
					var possible_attack_positions: Array[Variant] = [attack_positions.CEILING, attack_positions.HALLWAY];
					attack_position = possible_attack_positions.pick_random();
					if attack_position == attack_positions.HALLWAY:
						if flashlight_front.is_on:
							flashlight_front._turn_off();
						front_sprite.show();
						get_close_sound.pick_random().play();
					else:
						if flashlight_up.is_on:
							flashlight_up._turn_off();
						up_sprite.show();
						jump_sound.play();
				directions.RIGHT:
					var possible_attack_position: Variant = attack_positions.RIGHT_VENT;
					attack_position = possible_attack_position;
					if flashlight_right.is_on:
						flashlight_right._turn_off();
					right_sprite.show();
					right_vent.play();
