class_name CharacterMovementComponent extends Component

signal character_moved;

#variables
@export_range(main.AIMINVALUE, main.AIMAXVALUE) var ai_level: int = 0;

@export_group("Configurations")
@export var min_movement_timer: float = 0.0;
@export var max_movement_timer: float = 0.0;

@export var possible_directions: Array[String] = [];

@export var max_positions_in_directions: Dictionary[String, int] = {
	"Left Vent": 0,
	"Right Vent": 0,
	"Ceiling": 0,
	"Hallway": 0,
};

@export_group("Sprites")
@export var sprites_left_vent: Array[Sprite2D];
@export var sprites_right_vent: Array[Sprite2D];
@export var sprites_ceiling: Array[Sprite2D];
@export var sprites_hallway: Array[Sprite2D];

@export_group("Sprites Peek")
@export var sprite_peek_left_vent: Sprite2D;
@export var sprite_peek_right_vent: Sprite2D;
@export var sprite_peek_ceiling: Sprite2D;
@export var sprite_peek_hallway: Sprite2D;

@export_group("Sprites Shock")
@export var sprite_shock_left_vent: Sprite2D;
@export var sprite_shock_right_vent: Sprite2D;
@export var sprite_shock_ceiling: Sprite2D;
@export var sprite_shock_hallway: Sprite2D;

@export_group("Flashlight")
@export var turn_off_flashlight_when_moving : bool = true;
@export var turn_off_flashlight_when_reset : bool = false;
@export var flashlight_left_vent: FlashlightComponent;
@export var flashlight_right_vent: FlashlightComponent;
@export var flashlight_ceiling: FlashlightComponent;
@export var flashlight_hallway: FlashlightComponent;

@export_group("Audio")
@export var left_vent: AudioStreamPlayer2D;
@export var right_vent: AudioStreamPlayer2D;
@export var shock_sound: AudioStreamPlayer;

@export_group("Other")
@export var character_fadeaway_transition : AnimationPlayer;

var current_direction: String = "";

var current_position: int = -1;

var peeking: bool = false;
var shocked: bool = false;

var step: float = 0.0;
var movement_timer: float = 0.0;

#functions
func _ready() -> void:
	movement_timer = _get_randomized_movement_timer();

	if flashlight_left_vent != null: flashlight_left_vent.connect("flashlight_is_on", _left_flashlight_on);
	if flashlight_right_vent != null: flashlight_right_vent.connect("flashlight_is_on", _right_flashlight_on);
	if flashlight_ceiling != null: flashlight_ceiling.connect("flashlight_is_on", _ceiling_flashlight_on);
	if flashlight_hallway != null: flashlight_hallway.connect("flashlight_is_on", _hallway_flashlight_on);

	current_direction = possible_directions.pick_random();

func _physics_process(delta: float) -> void:
	if ai_level > 0:
		if current_position < max_positions_in_directions[current_direction]:
			step += delta * ai_level;
			if step >= movement_timer:
				step = 0;
				_move_character(turn_off_flashlight_when_moving);
				movement_timer = _get_randomized_movement_timer();
				character_moved.emit();

func _left_flashlight_on() -> void:
	if sprite_peek_left_vent != null:
		if sprite_peek_left_vent.visible:
			if !peeking:
				if sprite_peek_left_vent.get_node("AnimationPlayer").is_playing():
					sprite_peek_left_vent.get_node("AnimationPlayer").stop();
				sprite_peek_left_vent.get_node("AnimationPlayer").play("Peeking");
				peeking = true;

	if sprite_shock_left_vent != null:
		if sprite_shock_left_vent.visible:
			_shock_handler();

func _right_flashlight_on() -> void:
	if sprite_peek_right_vent != null:
		if sprite_peek_right_vent.visible:
			if !peeking:
				if sprite_peek_right_vent.get_node("AnimationPlayer").is_playing():
					sprite_peek_right_vent.get_node("AnimationPlayer").stop();
				sprite_peek_right_vent.get_node("AnimationPlayer").play("Peeking");
				peeking = true;

	if sprite_shock_right_vent != null:
		if sprite_shock_right_vent.visible:
			_shock_handler();

func _ceiling_flashlight_on() -> void:
	if sprite_peek_ceiling != null:
		if sprite_peek_ceiling.visible:
			if !peeking:
				if sprite_peek_ceiling.get_node("AnimationPlayer").is_playing():
					sprite_peek_ceiling.get_node("AnimationPlayer").stop();
				sprite_peek_ceiling.get_node("AnimationPlayer").play("Peeking");
				peeking = true;

	if sprite_shock_ceiling != null:
		if sprite_shock_ceiling.visible:
			_shock_handler();

func _hallway_flashlight_on() -> void:
	if sprite_peek_hallway != null:
		if sprite_peek_hallway.visible:
			if !peeking:
				if sprite_peek_hallway.get_node("AnimationPlayer").is_playing():
					sprite_peek_hallway.get_node("AnimationPlayer").stop();
				sprite_peek_hallway.get_node("AnimationPlayer").play("Peeking");
				peeking = true;

	if sprite_shock_hallway != null:
		if sprite_shock_hallway.visible:
			_shock_handler();

func _shock_handler() -> void:
	if !shocked:
		shock_sound.play();
		shocked = true;

func _get_randomized_movement_timer() -> float:
	return randf_range(min_movement_timer, max_movement_timer);

func _move_character(turn_off_flashlight : bool) -> void:
	current_position += 1;
	match (current_direction):
		"Left Vent":
			left_vent.play();
			if turn_off_flashlight:
				if flashlight_left_vent.is_flashlight_on:
					flashlight_left_vent._flashlight_off();
			for s in sprites_left_vent:
				s.hide();
			sprites_left_vent[current_position].show();
		"Right Vent":
			right_vent.play();
			if turn_off_flashlight:
				if flashlight_right_vent.is_flashlight_on:
					flashlight_right_vent._flashlight_off();
			for s in sprites_right_vent:
				s.hide();
			sprites_right_vent[current_position].show();
		"Hallway":
			if turn_off_flashlight:
				if flashlight_hallway.is_flashlight_on:
					flashlight_hallway._flashlight_off();
			for s in sprites_hallway:
				s.hide();
			sprites_hallway[current_position].show();
		"Ceiling":
			if turn_off_flashlight:
				if flashlight_ceiling.is_flashlight_on:
					flashlight_ceiling._flashlight_off();
			for s in sprites_ceiling:
				s.hide();
			sprites_ceiling[current_position].show();

func _reset_character_status(turn_flashlight_off : bool = true, enable_character_fadeaway : bool = true) -> void:
	if current_position > -1:
		shocked = false;
		peeking = false;

		if enable_character_fadeaway:
			if character_fadeaway_transition.is_playing():
				character_fadeaway_transition.stop();
			character_fadeaway_transition.play_backwards("fade");

		match (current_direction):
			"Left Vent":
				if turn_flashlight_off:
					if flashlight_left_vent.is_flashlight_on:
						flashlight_left_vent._flashlight_off();
				sprites_left_vent[current_position].hide();
			"Right Vent":
				if turn_flashlight_off:
					if flashlight_right_vent.is_flashlight_on:
						flashlight_right_vent._flashlight_off();
				sprites_right_vent[current_position].hide();
			"Ceiling":
				if turn_flashlight_off:
					if flashlight_ceiling.is_flashlight_on:
						flashlight_ceiling._flashlight_off();
				sprites_ceiling[current_position].hide();
			"Hallway":
				if turn_flashlight_off:
					if flashlight_hallway.is_flashlight_on:
						flashlight_hallway._flashlight_off();
				sprites_hallway[current_position].hide();

		current_direction = possible_directions.pick_random();
		current_position = -1;
		character_moved.emit();