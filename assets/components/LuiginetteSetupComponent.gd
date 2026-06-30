class_name LuiginetteSetupComponent extends Component

#variables
@export var active: bool = true;
@export var gameplay_node: Node;
@export var direction_handler: NightmareLuiginetteDirectionHandlerComponent;
@export var movement: CharacterMovementComponent;
@export var attack: CharacterAttackComponent;
@export var flashlight_mechanic: FlashlightMechanicComponent;
@export var mask_mechanic: MaskMechanicComponent;
@export var fnas3monitor: FNaS3MonitorComponent;

#functions
func _ready() -> void:
    if active:
        if main.nightcounter == 6 || main.nightcounter == 7:
            direction_handler.min_movements = main.luiginette_setup[main.nightcounter]["DirMinMovement"];
            direction_handler.max_movements = main.luiginette_setup[main.nightcounter]["DirMaxMovement"];

            direction_handler.movement_timer_min = main.luiginette_setup[main.nightcounter]["DirMinTimerMovement"];
            direction_handler.movement_timer_max = main.luiginette_setup[main.nightcounter]["DirMaxTimerMovement"];

            movement.min_movement_timer = main.luiginette_setup[main.nightcounter]["TimerMovementMin"];
            movement.max_movement_timer = main.luiginette_setup[main.nightcounter]["TimerMovementMax"];
            
            attack.timer_attack = main.luiginette_setup[main.nightcounter]["AttackTimer"];
            flashlight_mechanic.timer_counter = main.luiginette_setup[main.nightcounter]["FlashlightCounterTimer"];
            mask_mechanic.timer_counter = main.luiginette_setup[main.nightcounter]["MaskCounterTimer"];
        
            movement.max_positions_in_directions["Left Vent"] = main.luiginette_setup[main.nightcounter]["LeftVentPositionCount"];
            movement.max_positions_in_directions["Right Vent"] = main.luiginette_setup[main.nightcounter]["RightVentPositionCount"];
            movement.max_positions_in_directions["Ceiling"] = main.luiginette_setup[main.nightcounter]["CeilingPositionCount"];
            movement.max_positions_in_directions["Hallway"] = main.luiginette_setup[main.nightcounter]["HallwayPositionCount"];
            
            movement.sprites_left_vent.clear();
            movement.sprites_right_vent.clear();
            movement.sprites_ceiling.clear();
            movement.sprites_hallway.clear();

            for i in range(main.luiginette_setup[main.nightcounter]["LeftVentSprites"].size()):
                movement.sprites_left_vent.append(gameplay_node.get_node(main.luiginette_setup[main.nightcounter]["LeftVentSprites"][i]));

            for i in range(main.luiginette_setup[main.nightcounter]["RightVentSprites"].size()):
                movement.sprites_right_vent.append(gameplay_node.get_node(main.luiginette_setup[main.nightcounter]["RightVentSprites"][i]));

            for i in range(main.luiginette_setup[main.nightcounter]["CeilingSprites"].size()):
                movement.sprites_ceiling.append(gameplay_node.get_node(main.luiginette_setup[main.nightcounter]["CeilingSprites"][i]));

            for i in range(main.luiginette_setup[main.nightcounter]["HallwaySprites"].size()):
                movement.sprites_hallway.append(gameplay_node.get_node(main.luiginette_setup[main.nightcounter]["HallwaySprites"][i]));

            movement.turn_off_flashlight_in_hallway_when = main.luiginette_setup[main.nightcounter]["TurnOffFlashlightInHallwayWhen"];

            fnas3monitor.active = true;