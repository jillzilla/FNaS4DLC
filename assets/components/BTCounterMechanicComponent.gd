class_name BTCounterMechanicComponent extends Component

#variables
@export var player_component: Player_Component;
@export var movement_component: CharacterMovementComponent;
@export var attack_component: CharacterAttackComponent;
@export var flashlight_component: FlashlightComponent;

@export var flash_count: int = 5;

var flash: int = 0;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", bt_moved);
    flashlight_component.connect("flashlight_is_on", flashlight_is_on);

func flashlight_is_on() -> void:
    if attack_component.can_attack && player_component.direction == movement_component.current_direction.to_pascal_case():
        flash += 1;
        if flash >= flash_count:
            attack_component.can_attack = false;
            attack_component.step = 0;
            attack_component.pause = false;
            movement_component._reset_character_status(true, true);
            flash = 0;

func bt_moved() -> void:
    if movement_component.current_position == -1:
        flash = 0;