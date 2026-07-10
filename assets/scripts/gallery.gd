extends Node

#variables
@onready var loading: Control = $HUD/Loading;
@onready var room_name_text: Label = $HUD/Control/RoomNamePanel/RoomNameText;

var room_current: int = 0; # left office

@onready var rooms_list: Array[Camera2D] = [$OfficeCameraLeft, $OfficeCameraCenter, $OfficeCameraRight, $CameraLeftVent,
$CameraRightVent, $CameraCeiling, $CameraHallway];

@onready var characters_buttons: Dictionary[String, TextureButton] = {
    "Nightmare Toy Sonic": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Sonic,
    "Nightmare Toy Mario": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Mario,
    "Nightmare Toy Yoshi": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Yoshi,
    "Nightmare Taingle": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Tails,
    "Nightmare BT": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/BT,
    "Nightmare S. Sonic": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Salvage,
    "Nightmare Cream": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Cream,
    "Nightmare Knuckles": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Knuckles,
    "Tails Doll": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/TailsDoll,
    "Nightmare Luiginette": $HUD/Control/Characters/MarginContainer/ScrollContainer/Buttons/Luiginette,
};

const COUNTER_PATH: String = "MarginContainer/CharacterState";

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
};

var characters_states: Dictionary[String, int] = {
    "Nightmare Toy Sonic": - 1,
    "Nightmare Toy Mario": - 1,
    "Nightmare Toy Yoshi": - 1,
    "Nightmare Taingle": - 1,
    "Nightmare BT": - 1,
    "Nightmare S. Sonic": - 1,
    "Nightmare Cream": - 1,
    "Nightmare Knuckles": - 1,
    "Tails Doll": - 1,
    "Nightmare Luiginette": - 1,
}

@onready var sprites_manager: Dictionary[String, Dictionary] = {
    "Office (Left)": {
        "Nightmare BT": {
            0: [$Office/BT_2],
        },
        "Nightmare S. Sonic": {
            0: [$CameraEmpty/Salvage_1],
            1: [$CameraEmpty/Salvage_2],
            2: [$CameraEmpty/Salvage_3],
            3: [$CameraEmpty/Salvage_4],
        },
        "Nightmare Luiginette": {
            0: [$CameraEmpty/Lnette1],
            1: [$CameraEmpty/Lnette2],
            2: [$CameraEmpty/Lnette3],
            3: [$CameraEmpty/Lnette4],
        },
    },
    "Office (Center)": {
        "Nightmare BT": {
            0: [$Office/BT_2],
        },
        "Nightmare S. Sonic": {
            0: [$CameraEmpty/Salvage_1],
            1: [$CameraEmpty/Salvage_2],
            2: [$CameraEmpty/Salvage_3],
            3: [$CameraEmpty/Salvage_4],
        },
        "Nightmare Luiginette": {
            0: [$CameraEmpty/Lnette1],
            1: [$CameraEmpty/Lnette2],
            2: [$CameraEmpty/Lnette3],
            3: [$CameraEmpty/Lnette4],
        },
    },
    "Office (Right)": {
        "Nightmare BT": {
            0: [$Office/BT_2],
        },
        "Nightmare S. Sonic": {
            0: [$CameraEmpty/Salvage_1],
            1: [$CameraEmpty/Salvage_2],
            2: [$CameraEmpty/Salvage_3],
            3: [$CameraEmpty/Salvage_4],
        },
        "Nightmare Luiginette": {
            0: [$CameraEmpty/Lnette1],
            1: [$CameraEmpty/Lnette2],
            2: [$CameraEmpty/Lnette3],
            3: [$CameraEmpty/Lnette4],
        },
    },
};

var characters_state_in_rooms: Dictionary[String, Dictionary] = {
    "Office (Left)": {
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 3,
        "Nightmare Luiginette": 3,
    },
    "Office (Center)": {
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 3,
        "Nightmare Luiginette": 3,
    },
    "Office (Right)": {
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 3,
        "Nightmare Luiginette": 3,
    },
};

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
    if room_current > 2:
        for i in range(main._get_ai_level_as_array().size()):
            characters_states[main._get_ai_level_as_array()[i]] = -1;
            update_character_counters(main._get_ai_level_as_array()[i], characters_buttons[main._get_ai_level_as_array()[i]])
        for i in range(rooms_name.size()):
            if sprites_manager.has(rooms_name[i]):
                for j in range(main._get_ai_level_as_array().size()):
                    if sprites_manager[rooms_name[i]].has(main._get_ai_level_as_array()[j]):
                        for l in range(sprites_manager[rooms_name[i]][main._get_ai_level_as_array()[j]].size()):
                            for k in sprites_manager[rooms_name[i]][main._get_ai_level_as_array()[j]][l].size():
                                sprites_manager[rooms_name[i]][main._get_ai_level_as_array()[j]][l][k].hide();
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

func _on_sonic_pressed() -> void:
    _handle_characters_stuff("Nightmare Toy Sonic", characters_buttons["Nightmare Toy Sonic"]);

func _on_mario_pressed() -> void:
    _handle_characters_stuff("Nightmare Toy Mario", characters_buttons["Nightmare Toy Mario"]);

func _on_yoshi_pressed() -> void:
    _handle_characters_stuff("Nightmare Toy Yoshi", characters_buttons["Nightmare Toy Yoshi"]);

func _on_tails_pressed() -> void:
    _handle_characters_stuff("Nightmare Taingle", characters_buttons["Nightmare Taingle"]);

func _on_bt_pressed() -> void:
    _handle_characters_stuff("Nightmare BT", characters_buttons["Nightmare BT"]);

func _on_salvage_pressed() -> void:
    _handle_characters_stuff("Nightmare S. Sonic", characters_buttons["Nightmare S. Sonic"]);

func _on_cream_pressed() -> void:
    _handle_characters_stuff("Nightmare Cream", characters_buttons["Nightmare Cream"]);

func _on_knuckles_pressed() -> void:
    _handle_characters_stuff("Nightmare Knuckles", characters_buttons["Nightmare Knuckles"]);

func _on_tails_doll_pressed() -> void:
    _handle_characters_stuff("Tails Doll", characters_buttons["Tails Doll"]);

func _on_luiginette_pressed() -> void:
    _handle_characters_stuff("Nightmare Luiginette", characters_buttons["Nightmare Luiginette"]);

func _handle_characters_stuff(charname: String, button: TextureButton) -> void:
    characters_states[charname] += 1;
    if characters_states[charname] > characters_state_in_rooms[rooms_name[room_current]][charname]:
        characters_states[charname] = -1;
    for i in range(sprites_manager[rooms_name[room_current]][charname].size()):
        for j in range(sprites_manager[rooms_name[room_current]][charname][i].size()):
            sprites_manager[rooms_name[room_current]][charname][i][j].hide();
    if characters_states[charname] != -1:
        for i in range(sprites_manager[rooms_name[room_current]][charname][characters_states[charname]].size()):
            sprites_manager[rooms_name[room_current]][charname][characters_states[charname]][i].show();
    button.get_node(COUNTER_PATH).text = str(characters_states[charname] + 1);

func update_character_counters(charname: String, button: TextureButton) -> void:
    button.get_node(COUNTER_PATH).text = str(characters_states[charname] + 1);