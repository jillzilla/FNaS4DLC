extends Control

@export var icons : Array[TextureButton];

func _ready() -> void:
	if main.night_to_play >= 3:
		icons[5].show();
	if main.night_to_play >= 4:
		icons[6].show();
	if main.night_to_play >= 5:
		icons[9].show();
	if main.night6ending:
		icons[7].show();
		icons[8].show();
		
func _on_back_pressed() -> void:
	self.hide();
