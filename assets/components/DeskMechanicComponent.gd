class_name DeskMechanicComponent extends Component

#variables
const STARTPOSLEFT: float = -1240;
const STARTPOSRIGHT: float = 1240;

const ENDPOSLEFT: float = 1240;
const ENDPOSRIGHT: float = -1240;

const BODYPARTMINSCALE: float = 1;
const BODYPARTMAXSCALE: float = 1.2;

@onready var tween_movement: Tween = null;

@export var enable: bool = true;

@export_group("Components")
@export var player_component: Player_Component;
@export var character_attack_component: CharacterAttackComponent;
@export var character_movement_component: CharacterMovementComponent;
@export var desk_room_component: RoomComponent;

@export_group("Resources")
@export var desk_character_animation: Node2D;
@export var timer_step: Timer;
@export var right_foot: Sprite2D;
@export var left_foot: Sprite2D;

@export_group("Custom Flags")
@export var animation_speed: float = 0.0;
@export var do_the_character_fade_away_effect_when_reset: bool = false;
@export var play_vent_sound_when_reset: bool = true;

var switch_parts_right: bool = true;
var switch_parts_left: bool = false;

#functions
func _ready() -> void:
    desk_room_component.connect("_player_went_to_room", _player_is_under_desk);
    if timer_step != null:
        timer_step.connect("timeout", _step_timer_timeout);

func _player_is_under_desk() -> void:
    if enable:
        if character_movement_component.shocked:
            player_component.characters_walking_on_desk.push_back(self);
            
            if player_component.can_move:
                player_component.can_move = false;

            character_attack_component.can_attack = false;
            character_attack_component.step = 0;

            if timer_step != null:
                timer_step.start();

            if tween_movement:
                tween_movement.kill();
            tween_movement = create_tween();

            var start: float = 0;
            var end: float = 0;

            match (character_movement_component.current_direction):
                "Right Vent":
                    if left_foot != null && right_foot != null:
                        if !switch_parts_right:
                            _switch_feet_layer_index();
                            left_foot.scale = Vector2(BODYPARTMINSCALE, BODYPARTMINSCALE);
                            right_foot.scale = Vector2(BODYPARTMAXSCALE, BODYPARTMAXSCALE);
                            switch_parts_left = false;
                            switch_parts_right = true;
                    desk_character_animation.scale.x = 1;
                    start = STARTPOSRIGHT;
                    end = ENDPOSRIGHT;
                _:
                    if left_foot != null && right_foot != null:
                        if !switch_parts_left:
                            _switch_feet_layer_index();
                            desk_character_animation.left_foot.scale = Vector2(BODYPARTMAXSCALE, BODYPARTMAXSCALE);
                            right_foot.scale = Vector2(BODYPARTMINSCALE, BODYPARTMINSCALE);
                            switch_parts_left = true;
                            switch_parts_right = false;
                    desk_character_animation.scale.x = -1;
                    start = STARTPOSLEFT;
                    end = ENDPOSLEFT;

            desk_character_animation.position.x = start;
            desk_character_animation.show();

            tween_movement.tween_property(desk_character_animation, "position:x", end, animation_speed);

            await tween_movement.finished;

            if timer_step != null:
                timer_step.stop();

            player_component.characters_walking_on_desk.pop_front();

            if player_component.characters_walking_on_desk == []:
                player_component.can_move = true;

            character_movement_component._reset_character_status(do_the_character_fade_away_effect_when_reset, play_vent_sound_when_reset);

func _step_timer_timeout() -> void:
    if enable:
        timer_step.play();

func _switch_feet_layer_index() -> void:
    var index_a: int = right_foot.get_index();
    var index_b: int = left_foot.get_index();
    var index_c: int = index_a;

    index_a = index_b;
    index_b = index_c;

    desk_character_animation.move_child(right_foot, index_a);
    desk_character_animation.move_child(left_foot, index_b);