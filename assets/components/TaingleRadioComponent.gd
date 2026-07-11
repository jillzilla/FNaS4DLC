class_name TaingleRadioComponent extends Component

#variables
@export var radio: AudioStreamPlayer = null;
@export var taingle_movement_component: CharacterMovementComponent = null;

#functions
func _ready() -> void:
	taingle_movement_component.connect("character_moved", _taingle_moved);

func _taingle_moved() -> void:
	match (taingle_movement_component.current_position):
		0:
			radio.volume_db = -15;
		1:
			radio.volume_db = -10;
		2:
			radio.volume_db = -5;
		3:
			radio.volume_db = -0;
		_:
			radio.volume_db = -80;