extends CanvasLayer

@onready var counter : Label = $MarginContainer/Panel/Label;
@onready var margin_container : MarginContainer = $MarginContainer;

#functions
func _process(_delta: float) -> void:
	if margin_container.visible:
		counter.text = "FPS: " + str(Engine.get_frames_per_second());
