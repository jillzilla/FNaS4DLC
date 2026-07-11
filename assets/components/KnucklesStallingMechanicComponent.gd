class_name KnucklesStallingMechanicComponent extends Component

#variables
const POSITIONTOSTALLCHARACTER: int = 0;

@export var player_component: Player_Component = null;
@export var movement_component: CharacterMovementComponent = null;
@export var hallway_room_component: RoomComponent = null;
@export var office_room_component: RoomComponent = null;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", knux_moved);
    hallway_room_component.connect("_player_went_to_room", player_went_to_hallway);
    office_room_component.connect("_player_went_to_room", player_went_to_office);

func player_went_to_hallway() -> void:
    _stall_knuckles();

func player_went_to_office() -> void:
    if movement_component.pause:
        movement_component.pause = false;

func knux_moved() -> void:
    if player_component.direction == movement_component.current_direction.to_pascal_case():
        _stall_knuckles();

func _stall_knuckles() -> void:
    if movement_component.current_position == POSITIONTOSTALLCHARACTER:
        movement_component.pause = true;
        movement_component.movement_timer = movement_component._get_randomized_movement_timer();
        movement_component.step = 0;