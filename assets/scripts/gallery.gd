extends Node

#variables
@onready var loading: Control = $HUD/Loading;
@onready var room_name_text: Label = $HUD/Control/RoomNamePanel/RoomNameText;

var room_current: int = 0; # left office

@export var rooms_list: Array[Camera2D] = [];
@export var characters_buttons: Dictionary[String, TextureButton];

var rooms_name: Array[String] = ["Office (Left)", "Office (Center)", "Office (Right)", "Left Vent",
"Right Vent", "Ceiling", "Hallway"];

@onready var hud: Control = $HUD/Control;

var characters_button_manager: Dictionary[String, Dictionary] = {
    "Office (Left)": {
		"Nightmare Toy Sonic": false,
		"Nightmare Toy Mario": false,
		"Nightmare Toy Yoshi": false,
		"Nightmare Taingle": false,
		"Nightmare BT": true,
		"Nightmare S. Sonic": true,
		"Nightmare Cream": false,
		"Nightmare Knuckles": false,
		"Tails Doll": false,
		"Nightmare Luiginette": true,
    },
    "Office (Center)": {
		"Nightmare Toy Sonic": false,
		"Nightmare Toy Mario": false,
		"Nightmare Toy Yoshi": false,
		"Nightmare Taingle": false,
		"Nightmare BT": true,
		"Nightmare S. Sonic": true,
		"Nightmare Cream": false,
		"Nightmare Knuckles": false,
		"Tails Doll": false,
		"Nightmare Luiginette": true,
    },
    "Office (Right)": {
		"Nightmare Toy Sonic": false,
		"Nightmare Toy Mario": false,
		"Nightmare Toy Yoshi": false,
		"Nightmare Taingle": false,
		"Nightmare BT": true,
		"Nightmare S. Sonic": true,
		"Nightmare Cream": false,
		"Nightmare Knuckles": false,
		"Tails Doll": false,
		"Nightmare Luiginette": true,
    },
    "Left Vent": {
		"Nightmare Toy Sonic": true,
		"Nightmare Toy Mario": false,
		"Nightmare Toy Yoshi": true,
		"Nightmare Taingle": false,
		"Nightmare BT": true,
		"Nightmare S. Sonic": false,
		"Nightmare Cream": false,
		"Nightmare Knuckles": false,
		"Tails Doll": true,
		"Nightmare Luiginette": true,
    },
    "Right Vent": {
		"Nightmare Toy Sonic": true,
		"Nightmare Toy Mario": true,
		"Nightmare Toy Yoshi": false,
		"Nightmare Taingle": false,
		"Nightmare BT": false,
		"Nightmare S. Sonic": false,
		"Nightmare Cream": true,
		"Nightmare Knuckles": false,
		"Tails Doll": true,
		"Nightmare Luiginette": true,
    },
    "Ceiling": {
		"Nightmare Toy Sonic": false,
		"Nightmare Toy Mario": false,
		"Nightmare Toy Yoshi": false,
		"Nightmare Taingle": true,
		"Nightmare BT": false,
		"Nightmare S. Sonic": false,
		"Nightmare Cream": false,
		"Nightmare Knuckles": false,
		"Tails Doll": true,
		"Nightmare Luiginette": true,
    },
    "Hallway": {
		"Nightmare Toy Sonic": false,
		"Nightmare Toy Mario": false,
		"Nightmare Toy Yoshi": false,
		"Nightmare Taingle": false,
		"Nightmare BT": false,
		"Nightmare S. Sonic": true,
		"Nightmare Cream": false,
		"Nightmare Knuckles": true,
		"Tails Doll": false,
		"Nightmare Luiginette": true,
    },
}

#functions
func _ready() -> void:
    DiscordManager._update_details("Gallery");

func _on_back_button_pressed() -> void:
    loading._load_scene("uid://bk0janpvstfkp");

func _on_left_pressed() -> void:
    room_current -= 1;
    if room_current < 0:
        room_current = rooms_list.size() - 1;
    _switch_room();

func _on_right_pressed() -> void:
    room_current += 1;
    if room_current > rooms_list.size() - 1:
        room_current = 0;
    _switch_room();

func _switch_room() -> void:
    for r in rooms_list:
        r.enabled = false;
    rooms_list[room_current].enabled = true;
    room_name_text.text = rooms_name[room_current];
    _handle_characters_buttons();

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("HIDEHUDGALLERY"):
        if hud.visible:
            hud.hide();
        else:
            hud.show();

func _handle_characters_buttons() -> void:
    for i in range(main._get_ai_level_as_array().size()):
        characters_buttons[main._get_ai_level_as_array()[i]].modulate.a = 0.1;
        characters_buttons[main._get_ai_level_as_array()[i]].disabled = true;
    for i in range(main._get_ai_level_as_array().size()):
        if characters_button_manager[rooms_name[room_current]][main._get_ai_level_as_array()[i]]:
            characters_buttons[main._get_ai_level_as_array()[i]].modulate.a = 1;
            characters_buttons[main._get_ai_level_as_array()[i]].disabled = false;