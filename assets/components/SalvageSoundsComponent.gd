class_name SalvageSoundsComponent extends Component

#variables
@export var movement_component: CharacterMovementComponent;
@export var laugh: AudioStreamPlayer;
@export var danger_sound: AudioStreamPlayer;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", _salvage_is_moving);

func _salvage_is_moving() -> void:
    if movement_component.current_position == 4:
        if !danger_sound.is_playing():
            laugh.play();
            danger_sound.play();
    elif movement_component.current_position < 4:
        laugh.stop();
        danger_sound.stop();