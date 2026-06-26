class_name NightmareLuiginetteDirectionHandlerComponent extends Component

#variables
enum directions {LEFT, MIDDLE, RIGHT};
var direction: Variant = directions.MIDDLE;

@export_group("Stats")
@export var min_movements: int = 0;
@export var max_movements: int = 0;

@export var movement_timer_min: float = 0.0;
@export var movement_timer_max: float = 0.0;

@export_group("Resources")
@export var player_component: Player_Component;
@export var movement_component: CharacterMovementComponent;

@export_group("Audio")
@export var walk_left: AudioStreamPlayer2D;
@export var walk_right: AudioStreamPlayer2D;
@export var walk_middle: AudioStreamPlayer2D;

var step: float = 0.0;
var movement: int = 0;

var timer_movement: float = 0;
var movements: int = 0;

#functions
func _ready() -> void:
    movement_component.connect("character_moved", luigi_moved);
    movements = randi_range(min_movements, max_movements);
    timer_movement = randf_range(movement_timer_min, movement_timer_max);

func _process(delta: float) -> void:
    if main.ai_levels[movement_component.character_ai_level_id] > 0:
        if player_component.is_alive:
            if movement < movements:
                step += delta * main.ai_levels[movement_component.character_ai_level_id];
                if step >= timer_movement:
                    match (direction):
                        directions.LEFT:
                            direction = directions.MIDDLE;
                            walk_middle.play();
                            walk_right.stop();
                            walk_left.stop();
                        directions.MIDDLE:
                            var possible_directions: Array[directions] = [directions.LEFT, directions.RIGHT];
                            direction = possible_directions.pick_random();
                            match (direction):
                                directions.LEFT:
                                    walk_middle.stop();
                                    walk_right.stop();
                                    walk_left.play();
                                directions.RIGHT:
                                    walk_middle.stop();
                                    walk_right.play();
                                    walk_left.stop();
                        directions.RIGHT:
                            direction = directions.MIDDLE;
                            walk_middle.play();
                            walk_right.stop();
                            walk_left.stop();
                    step = 0;
                    timer_movement = randf_range(movement_timer_min, movement_timer_max);
                    movement += 1;
                    if movement >= movements:
                        match (direction):
                            directions.LEFT:
                                movement_component.current_direction = "Left Vent";
                            directions.MIDDLE:
                                var possible_directions: Array[String] = ["Ceiling", "Hallway"];
                                movement_component.current_direction = possible_directions.pick_random();
                            directions.RIGHT:
                                movement_component.current_direction = "Right Vent";
                        movement_component.disabled = false;
    
func luigi_moved() -> void:
    if movement_component.current_position == -1:
        movement_component.disabled = true;
        movements = randi_range(min_movements, max_movements);
        movement = 0;