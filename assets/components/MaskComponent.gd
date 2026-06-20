class_name MaskComponent extends Component

signal mask_is_on;
signal mask_is_off;

#variables
const BREATHRADIUS: float = 50;
const BREATHSPEED: float = 2;
const MASKSPAWNPOSITIONY: float = 360.0;
const MASKDESPAWNPOSITIONY: float = -360.0;

@onready var mask_movement_tween: Tween = null;

@export_file_path("*.png") var mask_moving_texture_path: String = "";
@export_file_path("*.png") var mask_breath_texture_path: String = "";

@export var player_component: Player_Component;
@export var mask_sprite: Sprite2D;
@export var mask_on_SFX: AudioStreamPlayer;
@export var mask_off_SFX: AudioStreamPlayer;

var breath_time: float;

var can_breath: bool = false;
var is_using_mask: bool = false;

#functions
func _process(delta: float) -> void:
	if player_component.is_alive && player_component.can_use_mask:
		if Input.is_action_just_pressed("MASK"):
			if !is_using_mask:
				_put_mask();
			else:
				_take_off_mask();
	if can_breath:
		breath_time += delta * BREATHSPEED;
		mask_sprite.offset.x = BREATHRADIUS * sin(breath_time);
		mask_sprite.offset.y = BREATHRADIUS * sin(breath_time) * cos(breath_time);
	else:
		breath_time = 0;
		mask_sprite.offset.x = 0;
		mask_sprite.offset.y = 0;

func _put_mask() -> void:
	player_component.can_move = false;

	if player_component.flashlight:
		if player_component.flashlight.is_flashlight_on:
			player_component.flashlight._flashlight_off();
		player_component.flashlight.process_mode = Node.PROCESS_MODE_DISABLED;
	
	is_using_mask = true;
	mask_on_SFX.play();

	if mask_movement_tween:
		mask_movement_tween.kill();
	mask_movement_tween = create_tween();

	mask_movement_tween.tween_property(mask_sprite, "position:y", MASKSPAWNPOSITIONY, 0.2).set_trans(Tween.TRANS_CUBIC);

	await mask_movement_tween.finished;

	mask_sprite.texture = load(mask_breath_texture_path);
	can_breath = true;

	mask_is_on.emit();

func _take_off_mask() -> void:
	is_using_mask = false;
	mask_off_SFX.play();

	mask_sprite.texture = load(mask_moving_texture_path);
	can_breath = false;

	if mask_movement_tween:
		mask_movement_tween.kill();
	mask_movement_tween = create_tween();

	mask_movement_tween.tween_property(mask_sprite, "position:y", MASKDESPAWNPOSITIONY, 0.2).set_trans(Tween.TRANS_CUBIC);

	await mask_movement_tween.finished;
	player_component.can_move = true;
	player_component.flashlight.process_mode = Node.PROCESS_MODE_INHERIT;

	mask_is_off.emit();