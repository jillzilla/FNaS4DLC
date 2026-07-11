extends Node

#variables
@onready var loading: Control = $Loading;

#functions
func _ready() -> void:
    DiscordManager._update_details("Endless Mode Menu");
    
func _on_ready_pressed() -> void:
    main.nightcounter = main.ENDLESSID;

    if main.save_data_file.aggressive_mode:
        main.save_data_file.aggressive_mode = false;
    if main.save_data_file.limited_vision:
        main.save_data_file.limited_vision = false;
    if main.save_data_file.limited_flashlight:
        main.save_data_file.limited_flashlight = false;
    if main.save_data_file.slower_nights:
        main.save_data_file.slower_nights = false;
    main._save();

    loading._load_scene("uid://bocmtkamvkla5");

func _on_back_pressed() -> void:
    loading._load_scene("uid://bk0janpvstfkp");