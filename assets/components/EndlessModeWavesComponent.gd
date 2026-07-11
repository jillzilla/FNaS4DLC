class_name EndlessModeWavesComponent extends Component

#variables
@export var player_component: Player_Component = null;
@export var time_component: TimeComponent = null;
var waves_handler: Dictionary[int, Dictionary] = {
    0: {
        "Nightmare Toy Mario": randi_range(8, 12),
        "Nightmare Toy Yoshi": randi_range(8, 12),
    },
    2: {
        "Nightmare Taingle": randi_range(8, 12),
    },
    4: {
        "Nightmare BT": randi_range(8, 12),
    },
    6: {
        "Nightmare Toy Sonic": randi_range(8, 12),
    },
    8: {
        "Nightmare Cream": randi_range(8, 12),
    },
    10: {
        "Nightmare S. Sonic": randi_range(8, 12),
    },
    12: {
        "Nightmare Knuckles": randi_range(8, 12),
    },
    14: {
        "Tails Doll": randi_range(8, 12),
    },
    16: {
        "Nightmare Luiginette": randi_range(8, 12),
    },
}

#functions
func _update_ai_levels() -> void:
    if main.nightcounter == main.ENDLESSID:
        for i in range(main._get_ai_level_as_array().size()):
            if waves_handler[player_component.endless_mode_hours].has(main._get_ai_level_as_array()[i]):
                main.ai_levels[main._get_ai_level_as_array()[i]] = waves_handler[player_component.endless_mode_hours][main._get_ai_level_as_array()[i]];

func _ready() -> void:
    time_component.connect("trigger_event", hour_passed);
    _update_ai_levels();

func hour_passed() -> void:
    _update_ai_levels();