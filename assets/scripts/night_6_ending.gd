extends Node

#variables
@onready var animation_camera: AnimationPlayer = $Camera2D/AnimationPlayer;
@onready var flashanimation: AnimationPlayer = $Flash/AnimationPlayer;

@onready var click: AudioStreamPlayer = $Click;

@onready var erase: Button = $Erase;

@onready var label: Label = $Label;

@onready var loading: Control = $Loading;

#functions
func _ready() -> void:
    DiscordManager._update_details("Night 6 Ending");
    DiscordManager._update_state("");

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "movement":
        animation_camera.play("movement2");
    elif anim_name == "movement2":
        animation_camera.play("movement3");

func _on_erase_pressed() -> void:
    erase.queue_free();
    label.queue_free();
    flashanimation.play("flash");
    click.play();

func _on_button_pressed() -> void:
    loading._load_scene("uid://cl7jf3xdjegaf");