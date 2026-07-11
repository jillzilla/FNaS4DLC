class_name BTSoundsComponent extends Component

#variables
@export var laugh_sound: AudioStreamPlayer = null;
@export var movement_sounds: Array[AudioStreamPlayer2D] = [];
@export var movement_component: CharacterMovementComponent = null;
@export var attack_component: CharacterAttackComponent = null;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", bt_moved);
    attack_component.connect("attack", bt_attacked);

func bt_moved() -> void:
    if movement_component.current_position > -1:
        movement_sounds.pick_random().play();
    else:
        laugh_sound.stop();

func bt_attacked() -> void:
    laugh_sound.play();