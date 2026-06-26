class_name LuiginetteSetupComponent extends Component

#variables
@export var gameplay_node : Node;
@export_file("*.json") var data_json : String = "";

@export var movement : CharacterMovementComponent;
@export var attack : CharacterAttackComponent;
@export var flashlight_mechanic : FlashlightMechanicComponent;
@export var mask_mechanic : MaskMechanicComponent;

var data : Dictionary = {};

#functions
func _ready() -> void:
    var file: FileAccess = FileAccess.open(data_json, FileAccess.READ);
    var json_text: String = file.get_as_text();

    data = JSON.parse_string(json_text);

    file.close();

    if main.nightcounter == 6 || main.nightcounter == 7:
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