class_name LuiginetteMechanicsSelectionComponent extends Component

#variables
@export var movement_component: CharacterMovementComponent;
@export var mask_mechanic_component: MaskMechanicComponent;
@export var flashlight_mechanic_component: FlashlightMechanicComponent;
@export var desk_mechanic_component: DeskMechanicComponent;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", luiginette_moved);

func luiginette_moved() -> void:
    if movement_component.current_position == 0:
        match (movement_component.current_direction):
            "Left Vent":
               mask_mechanic_component.enable = true;
               flashlight_mechanic_component.enable = false;
               desk_mechanic_component.enable = false;
            "Right Vent":
               mask_mechanic_component.enable = true;
               flashlight_mechanic_component.enable = false;
               desk_mechanic_component.enable = false;
            "Ceiling":
               mask_mechanic_component.enable = false;
               flashlight_mechanic_component.enable = true;
               desk_mechanic_component.enable = false;
            "Hallway":
               mask_mechanic_component.enable = false;
               flashlight_mechanic_component.enable = false;
               desk_mechanic_component.enable = true;