extends Node

#variables
@export var custom_night_rewards: Array[Sprite2D];
@onready var monitor: Node2D = $Rooms/Office/Monitor;

@onready var secondary_flashlight: PointLight2D = $Rooms/SecondaryFlashlight;
@onready var darkness: CanvasModulate = $Rooms/Darkness;
@onready var max_mode_music: AudioStreamPlayer = $Sounds/MaxModeMusic;

#functions
func _ready() -> void:
    match (main.nightcounter):
        main.CUSTOMNIGHTID:
            DiscordManager._update_details("Surviving Custom Night");
        main.ENDLESSID:
            DiscordManager._update_details("Surviving Endless Mode");
        _:
            DiscordManager._update_details("Surviving Night " + str(main.nightcounter));

    if main.save_data_file.night_to_play >= 3:
        monitor.show();

    if main.save_data_file.limited_vision:
        darkness.color = Color(0, 0, 0, 1);
        secondary_flashlight.show();

    if main.nightcounter == main.CUSTOMNIGHTID && main.cnchallenge == "Hammer Heartbreak II" && main.save_data_file.aggressive_mode && main.save_data_file.limited_flashlight && main.save_data_file.limited_vision && main.save_data_file.slower_nights:
        max_mode_music.play();
    
    for i in range(main._get_challenges_as_array().size()):
        if main._get_challenges_as_array()[i] != "Custom Night":
            if main.save_data_file.custom_night_challenges[main._get_challenges_as_array()[i]]:
                custom_night_rewards[i - 1].show();

func _process(_delta: float) -> void:
    if main.save_data_file.limited_vision:
        secondary_flashlight.position = secondary_flashlight.get_global_mouse_position();