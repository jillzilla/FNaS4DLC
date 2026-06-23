class_name FlashlightMechanicComponent extends Component

#variables
@export var enable: bool = true;

@export var timer_counter: float = 0.0;

@export var position_where_counter_is_possible: int = 0;
@export var position_where_reset_is_possible: int = 0;

var step: float = 0.0;

@export_group("Configurations")
@export var player_component: Player_Component;
@export var movement_component: CharacterMovementComponent;
@export var attack_component: CharacterAttackComponent;
@export var flashlight_component: FlashlightComponent;

@export_group("Custom Flags")
@export var do_the_character_fade_away_effect_when_reset: bool = false;
@export var play_vent_sound_when_reset: bool = false;

#functions
func _ready() -> void:
    flashlight_component.connect("flashlight_is_on", flashlight_is_on);
    flashlight_component.connect("flashlight_is_off", flashlight_is_off);
    movement_component.connect("character_moved", character_moved);

func _process(delta: float) -> void:
    if enable:
        if movement_component.current_position >= position_where_counter_is_possible && player_component.direction == movement_component.current_direction.to_pascal_case() && flashlight_component.is_flashlight_on:
            step += delta;
            if step >= timer_counter:
                movement_component.step = 0;
                movement_component.pause = false;

                attack_component.can_attack = false;
                attack_component.step = 0;
                attack_component.pause = false;

                if movement_component.current_position != position_where_reset_is_possible:
                    movement_component.current_position -= 1;
                    movement_component._move_character(movement_component.turn_off_flashlight_when_moving)
                else:
                    movement_component._reset_character_status(do_the_character_fade_away_effect_when_reset, play_vent_sound_when_reset);
                
                step = 0;

func flashlight_is_on() -> void:
    if enable:
        if movement_component.current_position >= position_where_counter_is_possible && player_component.direction == movement_component.current_direction.to_pascal_case():
            attack_component.pause = true;
            movement_component.pause = true;

func flashlight_is_off() -> void:
    if enable:
        if movement_component.current_position >= position_where_counter_is_possible && player_component.direction == movement_component.current_direction.to_pascal_case():
            attack_component.pause = false;
            movement_component.pause = false;

func character_moved() -> void:
    step = 0;
    if enable:
        if movement_component.current_position >= position_where_counter_is_possible && player_component.direction == movement_component.current_direction.to_pascal_case() && flashlight_component.is_flashlight_on:
            attack_component.pause = true;
            movement_component.pause = true;