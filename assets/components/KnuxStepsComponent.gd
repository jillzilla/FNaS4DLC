class_name KnuxStepsComponent extends Component

#variables
@export var movement_component : CharacterMovementComponent;
@export var steps : AudioStreamPlayer;
var steps_played : bool = false;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", knux_moved);

func knux_moved() -> void:
    if movement_component.current_position == 0:
        if !steps_played:
            steps.play();
            steps_played = true;
    elif movement_component.current_position < 0:
        steps_played = false;