class_name LuiginetteSetupComponent extends Component

#variables
@export var active : bool = true;
@export var gameplay_node : Node;
@export_file("*.json") var data_json : String = "";

@export var direction_handler : NightmareLuiginetteDirectionHandlerComponent;
@export var movement : CharacterMovementComponent;
@export var attack : CharacterAttackComponent;
@export var flashlight_mechanic : FlashlightMechanicComponent;
@export var mask_mechanic : MaskMechanicComponent;
@export var fnas3monitor : FNaS3MonitorComponent;

var data : Dictionary = {};

#functions
func _ready() -> void:
    var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
    var json_text: String = file.get_as_text();

    data = JSON.parse_string(json_text);

    file.close();

    if active:
        if main.nightcounter == 6 || main.nightcounter == 7:
            direction_handler.min_movements = data["Night " + str(main.nightcounter)]["DirMinMovement"];
            direction_handler.max_movements = data["Night " + str(main.nightcounter)]["DirMaxMovement"];

            direction_handler.movement_timer_min = data["Night " + str(main.nightcounter)]["DirMinTimerMovement"];
            direction_handler.movement_timer_max = data["Night " + str(main.nightcounter)]["DirMaxTimerMovement"];

            movement.min_movement_timer = data["Night " + str(main.nightcounter)]["TimerMovementMin"];
            movement.max_movement_timer = data["Night " + str(main.nightcounter)]["TimerMovementMax"];
            
            attack.timer_attack = data["Night " + str(main.nightcounter)]["AttackTimer"];
            flashlight_mechanic.timer_counter = data["Night " + str(main.nightcounter)]["FlashlightCounterTimer"];
            mask_mechanic.timer_counter = data["Night " + str(main.nightcounter)]["MaskCounterTimer"];
        
            movement.max_positions_in_directions["Left Vent"] = data["Night " + str(main.nightcounter)]["LeftVentPositionCount"];
            movement.max_positions_in_directions["Right Vent"] = data["Night " + str(main.nightcounter)]["RightVentPositionCount"];
            movement.max_positions_in_directions["Ceiling"] = data["Night " + str(main.nightcounter)]["CeilingPositionCount"];
            movement.max_positions_in_directions["Hallway"] = data["Night " + str(main.nightcounter)]["HallwayPositionCount"];
            
            movement.sprites_left_vent.clear();
            movement.sprites_right_vent.clear();
            movement.sprites_ceiling.clear();
            movement.sprites_hallway.clear();

            for i in range(data["Night " + str(main.nightcounter)]["LeftVentSprites"].size()):
                movement.sprites_left_vent.append(gameplay_node.get_node(data["Night " + str(main.nightcounter)]["LeftVentSprites"][i]));

            for i in range(data["Night " + str(main.nightcounter)]["RightVentSprites"].size()):
                movement.sprites_right_vent.append(gameplay_node.get_node(data["Night " + str(main.nightcounter)]["RightVentSprites"][i]));

            for i in range(data["Night " + str(main.nightcounter)]["CeilingSprites"].size()):
                movement.sprites_ceiling.append(gameplay_node.get_node(data["Night " + str(main.nightcounter)]["CeilingSprites"][i]));

            for i in range(data["Night " + str(main.nightcounter)]["HallwaySprites"].size()):
                movement.sprites_hallway.append(gameplay_node.get_node(data["Night " + str(main.nightcounter)]["HallwaySprites"][i]));

            movement.turn_off_flashlight_in_hallway_when = data["Night " + str(main.nightcounter)]["TurnOffFlashlightInHallwayWhen"];

            fnas3monitor.active = true;