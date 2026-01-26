extends AudioStreamPlayer2D

#functions
func _process(_delta: float) -> void:
    match(main.PlayerPosition):
        "Office":
            if position != Vector2(1040,0):
                position = Vector2(1040,0);
        "Ceiling":
            if position != Vector2(1040,360):
                position = Vector2(1040,360);
        "Left_Vent":
            if position != Vector2(2080,0):
                position = Vector2(2080,0);
        "Right_Vent":
            if position != Vector2(0,0):
                position = Vector2(0,0);
        "Desk":
            if position != Vector2(1040,-360):
                position = Vector2(1040,-360);
        "Hallway":
            if position != Vector2(1040,720):
                position = Vector2(1040,720);