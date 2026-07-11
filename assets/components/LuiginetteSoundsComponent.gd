class_name LuiginetteSoundsComponent extends Component

#variables
@export var movement_component: CharacterMovementComponent = null;
@export var walking: Array[AudioStreamPlayer] = [];
@export var laughing: Array[AudioStreamPlayer] = [];
@export var jump: AudioStreamPlayer = null;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", luiginette_moved);

func luiginette_moved() -> void:
    if movement_component.current_position >= movement_component.max_positions_in_directions[movement_component.current_direction]:
        laughing.pick_random().play();
        match (movement_component.current_direction):
            "Ceiling":
                jump.play();
            "Hallway":
                walking.pick_random().play();