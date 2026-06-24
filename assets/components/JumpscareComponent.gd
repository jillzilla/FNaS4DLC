class_name JumpscareComponent extends Component

#variables
@export_group("Components")
@export var mask_component : MaskComponent;
@export var office_room_component : RoomComponent;
@export var player_component : Player_Component;
@export var clock_timer : Timer;
@export var character_attack_component : CharacterAttackComponent;

@export_group("Resources")
@export var jumpscare_animation : Node2D;

@export_group("Data IDs")
@export var game_over_name : String = "";
@export var jumpscare_sound_name : String = "";

#functions
func _ready() -> void:
    if character_attack_component != null:
        character_attack_component.connect("attack", _character_attack);

func _character_attack() -> void:
    if player_component.is_alive:
        clock_timer.stop();
        player_component.is_alive = false;

        if mask_component.is_using_mask:
            mask_component._take_off_mask();
            await mask_component.mask_is_off;

        if player_component.direction != "Office":
            office_room_component._go_to_room();
            await office_room_component._player_went_to_room;

        main.killedBy = game_over_name;
        jumpscare_animation.get_node("AnimationPlayer").play("jumpscare");
        GlobalAudioManager.get_node(jumpscare_sound_name).play();