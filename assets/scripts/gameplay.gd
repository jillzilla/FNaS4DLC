extends Node

#variables
@onready var monitor: Node2D = $Rooms/Office/Monitor;

#functions
func _ready() -> void:
	DiscordManager._update_details("Surviving Night " + str(main.nightcounter));

	if main.night_to_play >= 3:
		monitor.show();