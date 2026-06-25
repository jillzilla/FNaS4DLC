class_name NightmareShadowToyMarioComponent extends Component

#variables
const FADESPEED: float = 0.5;
const MINALPHA: float = 0.0;
const MAXALPHA: float = 1;

@export var sprite: Sprite2D;
@export var room: RoomComponent;

@export_range(0, 1) var random_encounter: float;

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();
@onready var tween_disappear: Tween = null;

#functions
func _ready() -> void:
    room.connect("_player_went_to_room", player_went_to_room);

func player_went_to_room() -> void:
    rng.randomize();
    if rng.randf() <= random_encounter:
        sprite.modulate.a = MAXALPHA;
        if tween_disappear:
            tween_disappear.kill();
        tween_disappear = create_tween();
        tween_disappear.tween_property(sprite, "modulate:a", MINALPHA, FADESPEED).set_trans(Tween.TRANS_CUBIC);