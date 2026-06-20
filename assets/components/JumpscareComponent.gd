class_name JumpscareComponent extends Component

#variables
@export var mask_component : MaskComponent;
@export var office_room_component : RoomComponent;
@export var player_component : Player_Component;
@export var character_attack_component : CharacterAttackComponent;

@export var jumpscare_animation : Node2D;

@export var game_over_name : String = "";
@export var jumpscare_sound_name : String = "";

#functions
func _ready() -> void:
    character_attack_component.connect("attack", _character_attack);

func _character_attack() -> void:
    player_component.is_alive = false;

    if mask_component.is_about_to_do_something:
        mask_component._take_off_mask();
        await mask_component.mask_is_off;

    if player_component.direction != "Office":
        office_room_component._go_to_room();
        await office_room_component._player_went_to_room;

    main.killedBy = game_over_name;
    jumpscare_animation.get_node("AnimationPlayer").play("jumpscare");
    GlobalAudioManager.get_node(jumpscare_sound_name).play();