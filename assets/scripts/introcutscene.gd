extends Node

#variables
@onready var loading: Control = $Loading;

#functions
func _ready() -> void:
	DiscordManager._update_details("Intro Cutscene");
	DiscordManager._update_state("");

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation":
		if !main.introscenewatched:
			main.introscenewatched = true;
			main._save_game();
		loading._load_scene("res://assets/scenes/title.tscn");