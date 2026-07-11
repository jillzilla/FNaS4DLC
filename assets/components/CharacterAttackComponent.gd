class_name CharacterAttackComponent extends Component

signal attack;

#variables
@export var timer_attack: float = 0.0;
@export_group("Configurations")
@export var player_component: Player_Component = null;
@export var mask_component: MaskComponent = null;
@export var character_movement_component: CharacterMovementComponent = null;

var can_attack: bool = false;
var is_attacking: bool = false;
var pause: bool = false;

var step: float = 0.0;

#functions
func _ready() -> void:
    character_movement_component.connect("character_moved", _character_moved);

func _process(delta: float) -> void:
    if !pause && player_component.is_alive && !player_component.is_moving && player_component.characters_walking_on_desk == [] && !mask_component.is_about_to_do_something && can_attack && !is_attacking:
        step += delta;
        if step >= timer_attack:
            attack.emit();
            match (character_movement_component.current_direction):
                "Left Vent":
                    character_movement_component.sprites_left_vent[character_movement_component.current_position].hide();
                "Right Vent":
                    character_movement_component.sprites_right_vent[character_movement_component.current_position].hide();
                "Ceiling":
                    character_movement_component.sprites_ceiling[character_movement_component.current_position].hide();
                "Hallway":
                    character_movement_component.sprites_hallway[character_movement_component.current_position].hide();
            can_attack = false;
            is_attacking = true;

func _character_moved() -> void:
    if character_movement_component.current_position >= character_movement_component.max_positions_in_directions[character_movement_component.current_direction]:
        can_attack = true;
    if character_movement_component.current_position < character_movement_component.max_positions_in_directions[character_movement_component.current_direction]:
        if can_attack:
            step = 0;
            can_attack = false;