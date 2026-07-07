extends TextureButton

#variables
@export var jumpscare_sound_name: String = "";
@export var jumpscare_animation: Node2D = null;
@export var input_locker: Control = null;

#functions
func _ready() -> void:
    connect("pressed", _button_pressed)

func _button_pressed() -> void:
    GlobalAudioManager.get_node(jumpscare_sound_name).play();
    input_locker.show();
    jumpscare_animation.get_node("AnimationPlayer").play("jumpscare");
    await jumpscare_animation.get_node("AnimationPlayer").animation_finished;
    jumpscare_animation.get_node("AnimationPlayer").stop();
    input_locker.hide();