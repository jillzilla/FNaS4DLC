class_name BTOfficeComponent extends Component

#variables
@export var player_component : Player_Component;
@export var movement_component : CharacterMovementComponent;
@export var office_room_component : RoomComponent;
@export var desk_room_component : RoomComponent;
@export var attack_component : CharacterAttackComponent;

@export var sprite : Sprite2D;
@export var flashlight_list : Array[FlashlightComponent];

@export var character_fade_away_effect : AnimationPlayer;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", bt_moved);
    attack_component.connect("attack", bt_attack);

func bt_attack() -> void:
    if player_component.direction == "Office":
        character_fade_away_effect.play_backwards("fade");
    elif player_component.direction == "Desk":
        office_room_component._go_to_room();
    sprite.show();
    for f in flashlight_list:
        f.disable = true;
    desk_room_component.disable = true;

func bt_moved() -> void:
    if movement_component.current_position < 0 && sprite.visible:
        sprite.hide();
        for f in flashlight_list:
            f.disable = false;
        desk_room_component.disable = false;