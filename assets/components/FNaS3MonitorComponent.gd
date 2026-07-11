class_name FNaS3MonitorComponent extends Component

#variables
const STATICMINALPHA: float = 0.5;
const STATICMAXALPHA: float = 1.0;
const FADEANIMSPEED: float = 1.0;

@export var active: bool = true;
@export var exceptions: Array[int] = [];
@export var movement_component: CharacterMovementComponent = null;
@export var timer_static_fade: Timer = null;
@export var change_cam_sound: AudioStreamPlayer = null;
@export var static_: AnimatedSprite2D = null;
@export var lost_signal_sprite: Sprite2D = null;

@onready var tween_static_fade: Tween = null;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", _salvage_is_moving);

func _salvage_is_moving() -> void:
    if active:
        if movement_component.current_direction == "Hallway":
            if !movement_component.current_position in exceptions:
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