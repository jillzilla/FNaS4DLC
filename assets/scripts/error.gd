extends Node

#variables
@onready var error_2: Sprite2D = $Error2;
@onready var timer_2: Timer = $Timer2;

#functions
func _ready() -> void:
    DiscordManager._update_details("???");
    DiscordManager._update_state("");

func _on_timer_timeout() -> void:
    error_2.show();
    timer_2.start();

func _on_timer_2_timeout() -> void:
    get_tree().quit(0);