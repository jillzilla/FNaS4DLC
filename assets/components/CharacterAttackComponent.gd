class_name CharacterAttackComponent extends Component

signal attack;

#variables
@export var timer_attack : float = 0.0;
@export var character_movement_component : CharacterMovementComponent;
@export var player_component : Player_Component;
@export var mask_component : MaskComponent;

var can_attack : bool = false;
var is_attacking : bool = false;

var step : float = 0.0;

#functions
func _ready() -> void:
    character_movement_component.connect("character_moved", _character_moved);

func _process(delta: float) -> void:
    if player_component.is_alive && !player_component.is_moving && !mask_component.is_about_to_do_something && can_attack && !is_attacking:
        step += delta;
        if step >= timer_attack:
            attack.emit();
            is_attacking = true;

func _character_moved() -> void:
    if character_movement_component.current_position >= character_movement_component.max_positions_in_directions[character_movement_component.current_direction]:
        can_attack = true;