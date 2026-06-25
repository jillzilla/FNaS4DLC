class_name TailsDollMechanicComponent extends Component

#variables
const TAILSDOLLEFFECTMIN: float = 0.0;
const TAILSDOLLEFFECTMAX: float = 1.0;
const FADESPEEDMAX: float = 30;
const FADESPEEDMIN: float = 0.5;

@export var player_component: Player_Component;
@export var movement_component: CharacterMovementComponent;

@export var eye_sprites_l_vent: Sprite2D;
@export var eye_sprites_r_vent: Sprite2D;
@export var eye_sprites_ceiling: Sprite2D;

@export var flashlight_left: FlashlightComponent;
@export var flashlight_right: FlashlightComponent;
@export var flashlight_ceiling: FlashlightComponent;

@export var tails_doll_effect: Sprite2D;

@onready var tween_face_fade: Tween = null;
@onready var tween_sprite_fade: Tween = null;
@onready var tween_eyes_fade: Tween = null;

var is_attacking: bool = false;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", tailsdoll_moved);
    flashlight_left.connect("flashlight_is_on", flashlight_is_on.bind(flashlight_left));
    flashlight_right.connect("flashlight_is_on", flashlight_is_on.bind(flashlight_right));
    flashlight_ceiling.connect("flashlight_is_on", flashlight_is_on.bind(flashlight_ceiling));

func tailsdoll_moved() -> void:
    if movement_component.current_position > -1:
        is_attacking = true;
        match (movement_component.current_direction):
            "Left Vent":
                eye_sprites_l_vent.show();
            "Right Vent":
                eye_sprites_r_vent.show();
            "Ceiling":
                eye_sprites_ceiling.show();
        if tween_face_fade != null:
            tween_face_fade.kill();
        tween_face_fade = create_tween();
        tween_face_fade.tween_property(tails_doll_effect, "modulate:a", TAILSDOLLEFFECTMAX, FADESPEEDMAX);
    else:
        if tails_doll_effect.modulate.a != 0:
            _make_face_disappear();
        eye_sprites_l_vent.hide();
        eye_sprites_r_vent.hide();
        eye_sprites_ceiling.hide();

func flashlight_is_on(flashlight: FlashlightComponent) -> void:
    if is_attacking:
        match (flashlight):
            flashlight_left:
                if movement_component.current_direction == "Left Vent" && player_component.direction == "LeftVent":
                    _kill_tailsdoll(movement_component.sprites_left_vent[movement_component.current_position], eye_sprites_l_vent);
            flashlight_right:
                if movement_component.current_direction == "Right Vent" && player_component.direction == "RightVent":
                    _kill_tailsdoll(movement_component.sprites_right_vent[movement_component.current_position], eye_sprites_r_vent);
            flashlight_ceiling:
                if movement_component.current_direction == "Ceiling" && player_component.direction == "Ceiling":
                    _kill_tailsdoll(movement_component.sprites_ceiling[movement_component.current_position], eye_sprites_ceiling);

func _kill_tailsdoll(sprite: Sprite2D, eyes: Sprite2D) -> void:
    is_attacking = false;
    
    _make_face_disappear();

    if tween_sprite_fade != null:
        tween_sprite_fade.kill();
    tween_sprite_fade = create_tween();
    tween_sprite_fade.tween_property(sprite, "modulate:a", TAILSDOLLEFFECTMIN, FADESPEEDMIN).set_trans(Tween.TRANS_CUBIC);
    
    if tween_eyes_fade != null:
        tween_eyes_fade.kill();
    tween_eyes_fade = create_tween();
    tween_eyes_fade.tween_property(eyes, "modulate:a", TAILSDOLLEFFECTMIN, FADESPEEDMIN).set_trans(Tween.TRANS_CUBIC);
   
    await tween_eyes_fade.finished;
    
    movement_component._reset_character_status(false,false);

    sprite.modulate.a = TAILSDOLLEFFECTMAX;
    eyes.modulate.a = TAILSDOLLEFFECTMAX;

func _make_face_disappear() -> void:
    if tween_face_fade != null:
        tween_face_fade.kill();
    tween_face_fade = create_tween();
    tween_face_fade.tween_property(tails_doll_effect, "modulate:a", TAILSDOLLEFFECTMIN, FADESPEEDMIN).set_trans(Tween.TRANS_CUBIC);