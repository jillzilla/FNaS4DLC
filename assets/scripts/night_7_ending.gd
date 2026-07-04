extends Node

#variables
@onready var loading: Control = $HUD/Loading;
@onready var animation_manager: AnimationPlayer = $AnimationPlayer;

#functions
func _ready() -> void:
    DiscordManager._update_details("Night 7 Ending");
    DiscordManager._update_state("");

func _on_button_pressed() -> void:
    animation_manager.play("Animation P2");

func _change_game_to_f2() -> void:
    var texture: Texture2D = preload("uid://xhixtjwlqopb");
    var image: Image = texture.get_image();

    if main.save_data_file.windowmode != 0:
        main.save_data_file.windowmode = 0;

    if main.save_data_file.resolution != 1:
        main.save_data_file.resolution = 1;

    main._apply_settings();
    main._save();

    DisplayServer.window_set_title("Five Nights at Sonic's 2");
    DisplayServer.window_set_icon(image);

func _change_game_to_f4dlc() -> void:
    var texture: Texture2D = preload("uid://dbfigk0lm0h00");
    var image: Image = texture.get_image();

    DisplayServer.window_set_title("Five Nights at Sonic's 4 DLC");
    DisplayServer.window_set_icon(image);

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "Animation P2":
        loading._load_scene("uid://cl7jf3xdjegaf");