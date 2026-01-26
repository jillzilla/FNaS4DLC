extends Node

#variables
@export var officeRoomTravel : RoomTravelComponent;

#functions
func _ready() -> void:
    GlobalAudioManager.get_node("Ambience").play();
    
    main.PlayerAlive = true;
    main.PlayerPosition = officeRoomTravel.room.name;
    main.PlayerNotMoving = true;