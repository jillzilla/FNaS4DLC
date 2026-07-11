class_name Night5Event extends Component

#variables
@export var timer_spawn_luiginette: Timer = null;

@export var time_component: TimeComponent = null;

@export var movement_component: Array[CharacterMovementComponent] = [];
@export var luiginette_movement_component: CharacterMovementComponent = null;

@export var luiginette_entrance: AudioStreamPlayer = null;

@export var character_fade_away: AnimationPlayer = null;
@export var clock_fall_animation: AnimationPlayer = null;

#functions
func _ready() -> void:
    timer_spawn_luiginette.connect("timeout", spawn_luiginette);
    time_component.connect("trigger_event", trigger_event);

func trigger_event() -> void:
    if main.nightcounter == 5:
        if time_component.clock_iteration == 4:
            for s in get_tree().get_nodes_in_group("GeneralSounds"):
                if s.is_playing():
                    s.stop();

            luiginette_entrance.play();

            character_fade_away.play_backwards("fade");
            clock_fall_animation.play("fall");

            for i in range(main._get_ai_level_as_array().size()):
                if main.ai_levels[main._get_ai_level_as_array()[i]] != main.ai_levels["Nightmare Luiginette"]:
                    main.ai_levels[main._get_ai_level_as_array()[i]] = 0;

            for mc in movement_component:
                if mc != luiginette_movement_component:
                    mc._reset_character_status(false, false);

            timer_spawn_luiginette.start();

func spawn_luiginette() -> void:
    main.ai_levels["Nightmare Luiginette"] = 20;