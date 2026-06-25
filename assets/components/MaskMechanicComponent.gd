class_name MaskMechanicComponent extends Component

#variables
@export var enable: bool = true;

@export var timer_counter: float = 0.0;

var step: float = 0.0;

@export_group("Configurations")
@export var player_component: Player_Component;
@export var movement_component: CharacterMovementComponent;
@export var attack_component: CharacterAttackComponent;
@export var mask_component: MaskComponent;

@export_group("Custom Flags")
@export var do_the_character_fade_away_effect_when_reset: bool = true;
@export var play_vent_sound_when_reset: bool = true;

#functions
func _ready() -> void:
    mask_component.connect("mask_is_on", _mask_is_on);
    mask_component.connect("mask_is_off", _mask_is_off);

func _process(delta: float) -> void:
    if enable:
        if player_component.direction == movement_component.current_direction.to_pascal_case() && attack_component.can_attack && movement_component.shocked && mask_component.is_using_mask:
            step += delta;
            if step >= timer_counter:
                attack_component.can_attack = false;
                attack_component.step = 0;
                attack_component.pause = false;
                movement_component._reset_character_status(do_the_character_fade_away_effect_when_reset, play_vent_sound_when_reset);
                step = 0;

func _mask_is_on() -> void:
    if enable:
        if player_component.direction == movement_component.current_direction.to_pascal_case() && attack_component.can_attack && movement_component.shocked:
            attack_component.pause = true;

func _mask_is_off() -> void:
    if enable:
        if player_component.direction == movement_component.current_direction.to_pascal_case() && attack_component.can_attack && movement_component.shocked:
            attack_component.pause = false;