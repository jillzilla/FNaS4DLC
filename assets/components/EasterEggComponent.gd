class_name EasterEggComponent extends Component

#variables
@export var sprite: Sprite2D;
@export var room: RoomComponent;

@export_range(0, 1) var random_encounter: float;

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

#functions
func _ready() -> void:
    room.connect("_player_went_to_room", player_went_to_room);

func player_went_to_room() -> void:
    rng.randomize();
    if rng.randf() <= random_encounter:
        sprite.show();
    else:
        sprite.hide();