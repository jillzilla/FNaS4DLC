extends Node

#variables
@onready var loading: Control = $Loading;
@onready var ui: Control = $Control;

@onready var tryagain: Button = $Control/TryAgainButton;
@onready var menubutton: Button = $Control/MenuButton;

@onready var fadeanimation: AnimationPlayer = $Fade/AnimationPlayer;

@onready var static_: AnimatedSprite2D = $Static;

@onready var current_score_endless: Label = $Control/CurrentScore;
@onready var current_hours_endless: Label = $Control/CurrentHours;
@onready var current_highscore_endless: Label = $Control/BestScore;
@onready var current_highhours_endless: Label = $Control/BestHours;
@onready var new_record_text: Label = $Control/Record;

#functions
func _ready() -> void:
    DiscordManager._update_details("Game Over...");
    DiscordManager._update_state("Killed by " + main.killedBy);

    if GlobalAudioManager.get_node("Ambience").is_playing():
        GlobalAudioManager.get_node("Ambience").stop();
    
    if main.killedBy != "":
        get_node(main.game_over_graphics[main.killedBy]["Character Path"]).show();
        get_node(main.game_over_graphics[main.killedBy]["Overlay"]).show();

    if main.nightcounter == main.ENDLESSID:
        current_hours_endless.text = "Current Hours: " + str(main.global_endless_hours).pad_zeros(3);
        current_score_endless.text = "Current Score: " + str(main.global_endless_score).pad_zeros(6);

        current_highhours_endless.text = "Best Hours: " + str(main.save_data_file.endless_mode_highscore_hours).pad_zeros(3);
        current_highscore_endless.text = "Best Score: " + str(main.save_data_file.endless_mode_highscore_score).pad_zeros(6);
        
        var new_record: bool = false;

        if main.global_highscore_endless_hours > main.save_data_file.endless_mode_highscore_hours:
            main.save_data_file.endless_mode_highscore_hours = main.global_highscore_endless_hours;
            new_record = true;
        
        if main.global_highscore_endless_score > main.save_data_file.endless_mode_highscore_score:
            main.save_data_file.endless_mode_highscore_score = main.global_highscore_endless_score;
            new_record = true;
        
        if new_record:
            new_record_text.show();
            main._save();

        current_hours_endless.show();
        current_score_endless.show();

        current_highhours_endless.show();
        current_highscore_endless.show();

func _on_try_again_button_pressed() -> void:
    tryagain.hide();
    menubutton.hide();
    fadeanimation.play("fade");
    await fadeanimation.animation_finished;
    loading._load_scene("uid://bocmtkamvkla5");

func _on_menu_button_pressed() -> void:
    tryagain.hide();
    menubutton.hide();
    fadeanimation.play("fade");
    await fadeanimation.animation_finished;
    loading._load_scene("uid://cl7jf3xdjegaf");
    
func _on_timer_timeout() -> void:
    ui.show();
    static_.modulate.a = 0.5;