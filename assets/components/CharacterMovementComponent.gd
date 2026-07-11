class_name CharacterMovementComponent extends Component

signal character_moved;

#variables
@export var disabled: bool = false;

@export_group("Configurations")
@export var character_ai_level_id: String = "";
@export var player_component: Player_Component;

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
@export var sprites_left_vent: Array[Sprite2D] = [];
@export var sprites_right_vent: Array[Sprite2D] = [];
@export var sprites_ceiling: Array[Sprite2D] = [];
@export var sprites_hallway: Array[Sprite2D] = [];

@export_group("Sprites Peek")
@export var sprite_peek_left_vent: Sprite2D = null;
@export var sprite_peek_right_vent: Sprite2D = null;
@export var sprite_peek_ceiling: Sprite2D = null;
@export var sprite_peek_hallway: Sprite2D = null;

@export_group("Sprites Shock")
@export var sprite_shock_left_vent: Sprite2D = null;
@export var sprite_shock_right_vent: Sprite2D = null;
@export var sprite_shock_ceiling: Sprite2D = null;
@export var sprite_shock_hallway: Sprite2D = null;

@export_group("Flashlight")
@export var turn_off_flashlight_when_moving: bool = true;
@export var flashlight_left_vent: FlashlightComponent = null;
@export var flashlight_right_vent: FlashlightComponent = null;
@export var flashlight_ceiling: FlashlightComponent = null;
@export var flashlight_hallway: FlashlightComponent = null;
@export var turn_off_flashlight_in_hallway_when: int = 0;

@export_group("Audio")
@export var left_vent: AudioStreamPlayer2D = null;
@export var right_vent: AudioStreamPlayer2D = null;
@export var shock_sound: AudioStreamPlayer = null;
@export var leave_vent_sound: AudioStreamPlayer = null;

@export_group("Other")
@export var can_move_when_hiding: bool = false;
@export var character_fadeaway_transition: AnimationPlayer = null;
@export var let_external_component_handle_direction: bool = false;

var current_direction: String = "";

var current_position: int = -1;

var peeking: bool = false;
var shocked: bool = false;

var step: float = 0.0;
var movement_timer: float = 0.0;

var pause: bool = false;

#functions
func _ready() -> void:
	if flashlight_left_vent != null: flashlight_left_vent.connect("flashlight_is_on", _left_flashlight_on);
	if flashlight_right_vent != null: flashlight_right_vent.connect("flashlight_is_on", _right_flashlight_on);
	if flashlight_ceiling != null: flashlight_ceiling.connect("flashlight_is_on", _ceiling_flashlight_on);
	if flashlight_hallway != null: flashlight_hallway.connect("flashlight_is_on", _hallway_flashlight_on);

	movement_timer = _get_randomized_movement_timer();

	if main.ai_levels[character_ai_level_id] > 0:
		if possible_directions != [] && !let_external_component_handle_direction:
			current_direction = possible_directions.pick_random();
		else:
			if !disabled:
				disabled = true;

func _physics_process(delta: float) -> void:
	if main.ai_levels[character_ai_level_id] > 0 && !pause && !disabled && player_component.is_alive:
		if can_move_when_hiding && player_component.characters_walking_on_desk == [] || !can_move_when_hiding:
			if current_position < max_positions_in_directions[current_direction]:
				if !main.save_data_file.aggressive_mode:
					step += delta * main.ai_levels[character_ai_level_id];
				else:
					step += delta * main.ai_levels[character_ai_level_id] * 1.05;
				if step >= movement_timer:
					step = 0;
					current_position += 1;
					_move_character(turn_off_flashlight_when_moving);

func _left_flashlight_on() -> void:
	if sprite_peek_left_vent != null:
		if sprite_peek_left_vent.visible:
			if !peeking:
				player_component._add_points_endless_mode(50);
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
				player_component._add_points_endless_mode(50);
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
				player_component._add_points_endless_mode(50);
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
				player_component._add_points_endless_mode(50);
				if sprite_peek_hallway.get_node("AnimationPlayer").is_playing():
					sprite_peek_hallway.get_node("AnimationPlayer").stop();
				sprite_peek_hallway.get_node("AnimationPlayer").play("Peeking");
				peeking = true;

	if sprite_shock_hallway != null:
		if sprite_shock_hallway.visible:
			_shock_handler();

func _shock_handler() -> void:
	if !shocked:
		player_component._add_points_endless_mode(100);
		shock_sound.play();
		shocked = true;

func _get_randomized_movement_timer() -> float:
	return randf_range(min_movement_timer, max_movement_timer);

func _move_character(turn_off_flashlight: bool) -> void:
	match (current_direction):
		"Left Vent":
			if left_vent:
				left_vent.play();
			if turn_off_flashlight:
				if flashlight_left_vent.is_flashlight_on:
					flashlight_left_vent._flashlight_off();
			for s in sprites_left_vent:
				s.hide();
			sprites_left_vent[current_position].show();
		"Right Vent":
			if right_vent:
				right_vent.play();
			if turn_off_flashlight:
				if flashlight_right_vent.is_flashlight_on:
					flashlight_right_vent._flashlight_off();
			for s in sprites_right_vent:
				s.hide();
			sprites_right_vent[current_position].show();
		"Hallway":
			if turn_off_flashlight:
				if current_position >= turn_off_flashlight_in_hallway_when:
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
	movement_timer = _get_randomized_movement_timer();
	character_moved.emit();

func _reset_character_status(enable_character_fadeaway: bool = true, play_leave_vent_sound: bool = true) -> void:
	if current_position > -1:
		player_component._add_points_endless_mode(200);

		if step != 0:
			step = 0;
			
		shocked = false;
		peeking = false;

		match (current_direction):
			"Left Vent":
				sprites_left_vent[current_position].hide();
			"Right Vent":
				sprites_right_vent[current_position].hide();
			"Ceiling":
				sprites_ceiling[current_position].hide();
			"Hallway":
				sprites_hallway[current_position].hide();

		if enable_character_fadeaway:
			if character_fadeaway_transition.is_playing():
				character_fadeaway_transition.stop();
			character_fadeaway_transition.play_backwards("fade");

		if play_leave_vent_sound:
			leave_vent_sound.play();

		if !let_external_component_handle_direction:
			current_direction = possible_directions.pick_random();
		current_position = -1;
		character_moved.emit();