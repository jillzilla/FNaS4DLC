extends Node

@onready var loading : Control = $Loading;
@onready var click : AudioStreamPlayer = $Click;

@onready var animation_camera : AnimationPlayer = $Camera2D/AnimationPlayer;

#functions
func _ready() -> void:
	DiscordManager._update_details("Night 6 Ending");
	DiscordManager._update_state("");

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "movement":
		animation_camera.play("movement2");
	elif anim_name == "movement2":
		animation_camera.play("movement3");
	elif anim_name == "movement3":
		pass;

func _on_erase_pressed() -> void:
	click.play();
	$Erase.queue_free();
	$Label.queue_free();
	$Flash/AnimationPlayer.play("flash");

func _on_button_pressed() -> void:
	loading._load_scene("res://assets/scenes/title.tscn");
	await loading.scene_loaded;
	get_tree().call_deferred("change_scene_to_packed", loading.scene_to_be_loaded);
