extends Node

#functions
func _on_timer_clock_fade_timeout() -> void:
    get_node("AnimationPlayer").play("default");
    await get_node("AnimationPlayer").animation_finished;
    get_node("Control/Clock2/AnimationPlayer").play("Colors");

func _on_sound_finished() -> void:
    get_tree().change_scene_to_file("res://assets/scenes/night_screen.tscn");