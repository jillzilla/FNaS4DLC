extends Node

#variables
@onready var loading: Control = $Loading;

#functions
func _ready() -> void:
    DiscordManager._update_details("Endless Mode Menu");
    
func _on_ready_pressed() -> void:
    loading._load_scene("uid://bocmtkamvkla5");

func _on_back_pressed() -> void:
    loading._load_scene("uid://bk0janpvstfkp");