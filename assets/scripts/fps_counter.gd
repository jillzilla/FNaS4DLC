extends CanvasLayer

@onready var counter : Label = $MarginContainer/Panel/Label;

#functions
func _process(_delta: float) -> void:
	if get_node("MarginContainer").visible:
		counter.text = "FPS: " + str(Engine.get_frames_per_second());
