class_name DeskMechanicComponent extends Component

#variables
const STARTPOSLEFT : float = -1240;
const STARTPOSRIGHT : float = 1240;

const ENDPOSLEFT : float = 1240;
const ENDPOSRIGHT : float = -1240;

@onready var tween_movement : Tween = null;

@export_group("Components")
@export var player_component: Player_Component;
@export var character_attack_component: CharacterAttackComponent;
@export var character_movement_component: CharacterMovementComponent;
@export var desk_room_component: RoomComponent;

@export_group("Resources")
@export var desk_character_animation: Node2D;

@export_group("Custom Flags")
@export var animation_speed : float = 0.0;
@export var do_the_character_fade_away_effect_when_reset : bool = false;
@export var play_vent_sound_when_reset : bool = true;

#functions
func _ready() -> void:
    desk_room_component.connect("_player_went_to_room", _player_is_under_desk);

    if desk_character_animation.get_node("Timer_Step") != null:
        desk_character_animation.get_node("Timer_Step").connect("timeout", _step_timer_timeout);

func _player_is_under_desk() -> void:
    if character_movement_component.shocked:
        player_component.can_move = false;
        
        character_attack_component.pause = true;

        if desk_character_animation.get_node("Timer_Step") != null:
            desk_character_animation.get_node("Timer_Step").start();

        if tween_movement:
            tween_movement.kill();
        
        tween_movement = create_tween();

        var start : float = 0;
        var end : float = 0;

        match(character_movement_component.current_direction):
            "Right Vent":
                desk_character_animation.scale.x = -1;
                start = STARTPOSRIGHT;
                end = ENDPOSRIGHT;
            _:
                desk_character_animation.scale.x = 1;
                start = STARTPOSLEFT;
                end = ENDPOSLEFT;

        desk_character_animation.position.x = start;
        desk_character_animation.show();

        tween_movement.tween_property(desk_character_animation, "position:x", end, animation_speed);

        await tween_movement.finished;

        if desk_character_animation.get_node("Timer_Step") != null:
            desk_character_animation.get_node("Timer_Step").stop();

        player_component.can_move = true;

        character_attack_component.step = 0;
        character_attack_component.can_attack = false;
        character_attack_component.pause = false;

        character_movement_component._reset_character_status(false, do_the_character_fade_away_effect_when_reset, play_vent_sound_when_reset);

func _step_timer_timeout() -> void:
    desk_character_animation.get_node("Steps").play();