class_name ToyMarioEyesComponent extends Component

#variables
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new();
@export var pupils : Array[Sprite2D];
@export var mario_movement_component : CharacterMovementComponent;

#functions
func _ready() -> void:
    mario_movement_component.connect("character_moved", _mario_ready);

func _mario_ready() -> void:
    if mario_movement_component.current_position == 0:
        rng.randomize();
        if rng.randf() <= 0.5:
            for p in pupils:
                p.show();
        else:
            for p in pupils:
                p.hide();