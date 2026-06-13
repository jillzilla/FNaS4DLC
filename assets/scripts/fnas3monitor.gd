extends Node2D

#variables
@onready var timer: Timer = Timer.new();

@export var changeSFX: AudioStreamPlayer;
@export var Static: AnimatedSprite2D;
@export var Lsignal: Sprite2D;
@export var salvage: SalvageSonic;

var didSignalLost: bool = false;

#functions
func _ready() -> void:
	call_deferred("add_child", timer);
	timer.wait_time = 1;
	timer.one_shot = true;
	salvage.connect("moved", _character_moved);

func _character_moved() -> void:
	didSignalLost = true;
	Lsignal.visible = true;
	Static.modulate.a = 1;
	timer.start();
	await timer.timeout;
	changeSFX.play();
	Lsignal.visible = false;
	var t: Tween = create_tween();
	t.tween_property(Static, "modulate:a", 0.6, 1).set_trans(Tween.TRANS_CUBIC);
	await t.finished;
	didSignalLost = false;
