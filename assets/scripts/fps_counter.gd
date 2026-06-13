extends CanvasLayer

#variables
@onready var counter: Label = $MarginContainer/Panel/Label;
@onready var ui: MarginContainer = $MarginContainer;

#functions
func _process(_delta: float) -> void:
	if ui.visible:
		counter.text = "FPS: " + str(Engine.get_frames_per_second());
