extends Button

#DEPRECATED

#variables
@export var Sound: AudioStreamPlayer2D;

#functions
func _on_pressed() -> void:
	if main.PlayerAlive && main.PlayerNotMoving:
		Sound.play();