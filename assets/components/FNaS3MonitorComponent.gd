class_name FNaS3MonitorComponent extends Component

#variables
const STATICMINALPHA: float = 0.5;
const STATICMAXALPHA: float = 1.0;
const FADEANIMSPEED: float = 1.0;
const POSITIONLIMIT: int = 5;
const EXCEPTIONS: Array[int] = [-1];

@export var movement_component: CharacterMovementComponent;
@export var timer_static_fade: Timer;
@export var change_cam_sound: AudioStreamPlayer;
@export var static_: AnimatedSprite2D;
@export var lost_signal_sprite: Sprite2D;

@onready var tween_static_fade: Tween = null;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", _salvage_is_moving);

func _salvage_is_moving() -> void:
    if movement_component.current_position < POSITIONLIMIT && !movement_component.current_position in EXCEPTIONS:
        movement_component.pause = true;
        if tween_static_fade:
            tween_static_fade.kill();
        lost_signal_sprite.show();
        static_.modulate.a = STATICMINALPHA;
        timer_static_fade.start();
        await timer_static_fade.timeout;
        change_cam_sound.play();
        lost_signal_sprite.hide();
        tween_static_fade = create_tween();
        static_.modulate.a = STATICMAXALPHA;
        tween_static_fade.tween_property(static_, "modulate:a", STATICMINALPHA, FADEANIMSPEED).set_trans(Tween.TRANS_CUBIC);
        await tween_static_fade.finished;
        movement_component.pause = false;