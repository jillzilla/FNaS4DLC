extends Node

#variables
@onready var save_data_file: SaveDataResource = SaveDataResource.new();

const SAVE_DATA_PATH: String = "user://FNaS4DLC.json";
const SAVE_DATA_PASSWORD: String = "2<0r2eX1&2:<Cd";

const AIMINVALUE: int = 0;
const AIDEFAULTLEVEL: int = 5;
const AIMAXVALUE: int = 25;

const CUSTOMNIGHTID: int = 7;
const ENDLESSID: int = 8;

const CANSKIPNIGHTS: bool = false;

var nightcounter: int = 1;

var killedBy: String = "";
var cnchallenge: String = "";

var global_endless_score: int = 0;
var global_endless_hours: int = 0;

var global_highscore_endless_score: int = 0;
var global_highscore_endless_hours: int = 0;

var isloadingsom: bool = false;
var didrarescreenhappened: bool = false;

var tutorials_text: Dictionary[int, String] = {
    1: "To navigate around your office, you’ll need to click on one of the\nentrances. You’ll be able to go to the vents, the hallway, the\nceiling, and finally under the desk.\n\nIf you hear a radio, go to the ceiling and shine the\nflashlight on it until the danger goes away.\n\nIf you hear noises coming from the vents, or if you're about to be\nattacked, remember that with the dinosaur you have to wear the\nmask, while with the plumber it depends on his pupils: if\nthey're visible, wear the mask; if they're invisible, hide\nunder the desk.\n\n Remember that you'll have to shine a light on them before you can\ndo anything to defend yourself, you can't hide from\nwhat you can't see.",
    2: "The two blue hedgehogs aren't fooled by the mask. If one\nof them dares to attack you from the vents,\nhide under the desk.\n\nA mushroom has also just sprouted tonight; if you\nhear its laughter coming from the left vent, turn\nyour flashlight on and off repeatedly until it\nleaves you alone.\n\nOtherwise, everything else is the same.\n\nGood luck.",
    3: "That other blue hedgehog will try to slowly approach\nyour position from the hallway. You can keep an\neye on him via the monitor above your desk; if\nyou hear him laughing, shine your flashlight\non him until he goes away.\n\nYou're close to the truth, Amy.",
    4: "An old friend of yours will be joining us tonight.\nShe won't be very dangerous, but if she tries to attack\nyou, hide under the desk. Nothing too complicated.",
    5: "Everyone you've met so far will be more aggressive\ntonight, but not for long... Things are going to\nchange, and when they do, keep this in mind:\n\nfrom the vents to the mask,\nfrom the hallway to the desk,\nfrom the ceiling to the flashlight.\n\nIt's time to shine.",
};

var ai_levels: Dictionary[String, int] = {
    "Nightmare Toy Sonic": AIDEFAULTLEVEL,
    "Nightmare Toy Mario": AIDEFAULTLEVEL,
    "Nightmare Toy Yoshi": AIDEFAULTLEVEL,
    "Nightmare Taingle": AIDEFAULTLEVEL,
    "Nightmare BT": AIDEFAULTLEVEL,
    "Nightmare S. Sonic": AIDEFAULTLEVEL,
    "Nightmare Cream": AIDEFAULTLEVEL,
    "Nightmare Knuckles": AIDEFAULTLEVEL,
    "Tails Doll": AIDEFAULTLEVEL,
    "Nightmare Luiginette": AIDEFAULTLEVEL,
};

var guide_text: Dictionary[String, String] = {
    "Nightmare Toy Sonic": "He can come from either side, so when he's about to attack, hide under the desk.",
    "Nightmare Toy Mario": "He'll come from the right vent. Just as he's about to attack, make sure to watch his eyes—if they're off, hide under the desk; if they're on, put on your mask.",
    "Nightmare Toy Yoshi": "She'll be coming from the left side; put on your mask just as she's about to attack.",
    "Nightmare Taingle": "When you hear the sound of her radio, look up at the ceiling and shine your flashlight on her until she disappears.",
    "Nightmare Balloon Toad": "He'll come from the left side; when you hear him laugh, go over there and keep turning the flashlight on and off until he leaves.",
    "Nightmare Salvage Sonic": "He'll come down the hallway; you'll be able to see where he is on the monitor on the desk. As soon as you hear him laugh, go to the hallway and shine the flashlight at him until he leaves.",
    "Nightmare Cream": "She'll come in from the right side; just as she's about to attack, hide under the desk.",
    "Nightmare Knuckles": "At the beginning of the night, he won't cause any trouble, but if you hear loud footsteps, you'll need to check the hallway every now and then to make sure he doesn't move from his spot. It's impossible to send him away, and letting him get too close will definitely get you killed.",
    "Tails Doll": "When he appears, he will slowly obscure your vision; guess where he is, and he will go away.",
    "Nightmare Luiginette": "He always starts from the center. Before he attacks, you’ll hear him running to the right, left, or center—if he isn’t already there. When he stops, it means he’s found the spot from which to attack. When you hear him laugh, it means he’s about to kill you, so you need to listen carefully for the sound he makes beyond his laughter. If you hear the sound of vents, it means he’s in one of them, and you’ll need to use the mask; if you hear a jumping sound, it means he’s on the ceiling, so you’ll need to use the flashlight; and if you hear footsteps, it means he’s in the center, and you’ll need to hide under the desk.",
};

var ai_nights: Dictionary[int, Dictionary] = {
    1: {
        "Nightmare Toy Sonic": 0,
        "Nightmare Toy Mario": 8,
        "Nightmare Toy Yoshi": 8,
        "Nightmare Taingle": 8,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },

    2: {
        "Nightmare Toy Sonic": 8,
        "Nightmare Toy Mario": 10,
        "Nightmare Toy Yoshi": 10,
        "Nightmare Taingle": 10,
        "Nightmare BT": 8,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },

    3: {
        "Nightmare Toy Sonic": 10,
        "Nightmare Toy Mario": 12,
        "Nightmare Toy Yoshi": 12,
        "Nightmare Taingle": 12,
        "Nightmare BT": 10,
        "Nightmare S. Sonic": 8,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },

    4: {
        "Nightmare Toy Sonic": 12,
        "Nightmare Toy Mario": 14,
        "Nightmare Toy Yoshi": 14,
        "Nightmare Taingle": 14,
        "Nightmare BT": 12,
        "Nightmare S. Sonic": 10,
        "Nightmare Cream": 8,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },

    5: {
        "Nightmare Toy Sonic": 14,
        "Nightmare Toy Mario": 15,
        "Nightmare Toy Yoshi": 15,
        "Nightmare Taingle": 15,
        "Nightmare BT": 14,
        "Nightmare S. Sonic": 12,
        "Nightmare Cream": 10,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },

    6: {
        "Nightmare Toy Sonic": 15,
        "Nightmare Toy Mario": 18,
        "Nightmare Toy Yoshi": 18,
        "Nightmare Taingle": 18,
        "Nightmare BT": 15,
        "Nightmare S. Sonic": 20,
        "Nightmare Cream": 18,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 18,
    },
};

var ai_custom_night_challenges: Dictionary[String, Dictionary] = {
    "4/20": {
        "Nightmare Toy Sonic": 20,
        "Nightmare Toy Mario": 20,
        "Nightmare Toy Yoshi": 20,
        "Nightmare Taingle": 20,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 10,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },
    "Nintendon't": {
        "Nightmare Toy Sonic": 13,
        "Nightmare Toy Mario": 0,
        "Nightmare Toy Yoshi": 0,
        "Nightmare Taingle": 15,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 18,
        "Nightmare Cream": 15,
        "Nightmare Knuckles": 18,
        "Tails Doll": 10,
        "Nightmare Luiginette": 0,
    },
    "Nintendo Power": {
        "Nightmare Toy Sonic": 0,
        "Nightmare Toy Mario": 15,
        "Nightmare Toy Yoshi": 15,
        "Nightmare Taingle": 0,
        "Nightmare BT": 10,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 18,
    },
    "Sonic VS. Mario": {
        "Nightmare Toy Sonic": 25,
        "Nightmare Toy Mario": 25,
        "Nightmare Toy Yoshi": 0,
        "Nightmare Taingle": 18,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 25,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 0,
        "Tails Doll": 18,
        "Nightmare Luiginette": 18,
    },
    "Friendly Fire": {
        "Nightmare Toy Sonic": 0,
        "Nightmare Toy Mario": 0,
        "Nightmare Toy Yoshi": 0,
        "Nightmare Taingle": 0,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 20,
        "Nightmare Knuckles": 17,
        "Tails Doll": 0,
        "Nightmare Luiginette": 21,
    },
    "Sidekick Hangout": {
        "Nightmare Toy Sonic": 0,
        "Nightmare Toy Mario": 0,
        "Nightmare Toy Yoshi": 0,
        "Nightmare Taingle": 25,
        "Nightmare BT": 25,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 25,
        "Tails Doll": 25,
        "Nightmare Luiginette": 25,
    },
    "Night Shift in Company": {
        "Nightmare Toy Sonic": 0,
        "Nightmare Toy Mario": 0,
        "Nightmare Toy Yoshi": 0,
        "Nightmare Taingle": 0,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 0,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 25,
        "Tails Doll": 0,
        "Nightmare Luiginette": 25,
    },
    "Panda Mode": {
        "Nightmare Toy Sonic": 21,
        "Nightmare Toy Mario": 14,
        "Nightmare Toy Yoshi": 7,
        "Nightmare Taingle": 14,
        "Nightmare BT": 1,
        "Nightmare S. Sonic": 11,
        "Nightmare Cream": 0,
        "Nightmare Knuckles": 0,
        "Tails Doll": 0,
        "Nightmare Luiginette": 4,
    },
    "Advance 3": {
        "Nightmare Toy Sonic": 0,
        "Nightmare Toy Mario": 0,
        "Nightmare Toy Yoshi": 0,
        "Nightmare Taingle": 15,
        "Nightmare BT": 0,
        "Nightmare S. Sonic": 15,
        "Nightmare Cream": 15,
        "Nightmare Knuckles": 15,
        "Tails Doll": 0,
        "Nightmare Luiginette": 0,
    },
    "Your Biggest Nightmare": {
        "Nightmare Toy Sonic": 8,
        "Nightmare Toy Mario": 8,
        "Nightmare Toy Yoshi": 8,
        "Nightmare Taingle": 8,
        "Nightmare BT": 8,
        "Nightmare S. Sonic": 8,
        "Nightmare Cream": 8,
        "Nightmare Knuckles": 8,
        "Tails Doll": 8,
        "Nightmare Luiginette": 8,
    },
    "Grand Re-Opening": {
        "Nightmare Toy Sonic": 20,
        "Nightmare Toy Mario": 20,
        "Nightmare Toy Yoshi": 20,
        "Nightmare Taingle": 20,
        "Nightmare BT": 20,
        "Nightmare S. Sonic": 20,
        "Nightmare Cream": 20,
        "Nightmare Knuckles": 20,
        "Tails Doll": 20,
        "Nightmare Luiginette": 20,
    },
    "Hammer Heartbreak II": {
        "Nightmare Toy Sonic": 25,
        "Nightmare Toy Mario": 25,
        "Nightmare Toy Yoshi": 25,
        "Nightmare Taingle": 25,
        "Nightmare BT": 25,
        "Nightmare S. Sonic": 25,
        "Nightmare Cream": 25,
        "Nightmare Knuckles": 25,
        "Tails Doll": 25,
        "Nightmare Luiginette": 25,
    },
};

@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
var _custom_night_rewards: Dictionary[String, Dictionary] = {
    "4/20": {
        "Icon": "uid://cmdsvegeu0ww0",
        "Text": "Nightmare Toy Sonic Plush",
    },
    "Nintendon't": {
        "Icon": "uid://bihmfm0eqlyum",
        "Text": "Nightmare Toy Mario Plush",
    },
    "Nintendo Power": {
        "Icon": "uid://dmm7rlfhepaso",
        "Text": "Nightmare Toy Yoshi Plush",
    },
    "Sonic VS. Mario": {
        "Icon": "uid://doqeg5cshxm0l",
        "Text": "Nightmare Taingle Plush",
    },
    "Friendly Fire": {
        "Icon": "uid://16s2imsk0e6m",
        "Text": "Nightmare Balloon Toad Plush",
    },
    "Sidekick Hangout": {
        "Icon": "uid://db00licd5elxu",
        "Text": "Nightmare S. Sonic Plush",
    },
    "Night Shift in Company": {
        "Icon": "uid://cyqph27ish18i",
        "Text": "Nightmare Cream Plush",
    },
    "Panda Mode": {
        "Icon": "uid://dombv50yugfx1",
        "Text": "Nightmare Knuckles Plush",
    },
    "Advance 3": {
        "Icon": "uid://casd7ww3lie6c",
        "Text": "Tails Doll Plush",
    },
    "Your Biggest Nightmare": {
        "Icon": "uid://bxsxgs6u0n1e4",
        "Text": "Paper Pal Sonic",
    },
    "Grand Re-Opening": {
        "Icon": "uid://dl4tm1qej5cbv",
        "Text": "Paper Pal Mario",
    },
    "Hammer Heartbreak II": {
        "Icon": "uid://jwvk3g07os8m",
        "Text": "Nightmare Luiginette Plush",
    },
};

var game_over_graphics: Dictionary[String, Dictionary] = {
    "Nightmare Toy Sonic": {
        "Character Path": "Characters/ToySonic",
        "Overlay": "Overlays/Mask"
    },
    "Nightmare Toy Mario": {
        "Character Path": "Characters/ToyMario",
        "Overlay": "Overlays/Mask"
    },
    "Nightmare Toy Yoshi": {
        "Character Path": "Characters/ToyYoshi",
        "Overlay": "Overlays/Mask"
    },
    "Nightmare Taingle": {
        "Character Path": "Characters/Taingle",
        "Overlay": "Overlays/Mask"
    },
    "Nightmare Salvage Sonic": {
        "Character Path": "Characters/Salvage",
        "Overlay": "AmyDeath"
    },
    "Nightmare Cream": {
        "Character Path": "Characters/Cream",
        "Overlay": "AmyDeath"
    },
    "Nightmare Knuckles": {
        "Character Path": "Characters/Knuckles",
        "Overlay": "AmyDeath"
    },
    "Nightmare Luiginette": {
        "Character Path": "Characters/Luigi",
        "Overlay": "Overlays/POV"
    }
};

var luiginette_setup: Dictionary[int, Dictionary] = {
    6: {
        "TimerMovementMin": 180.0,
        "TimerMovementMax": 240.0,
        "AttackTimer": 2.5,
        "FlashlightCounterTimer": 0.5,
        "MaskCounterTimer": 0.3,
        "LeftVentPositionCount": 1,
        "RightVentPositionCount": 1,
        "CeilingPositionCount": 0,
        "HallwayPositionCount": 2,
        "LeftVentSprites": [
            "Rooms/Left_Vent/LuiginetteVent1",
            "Rooms/Left_Vent/NLuigiVent"
        ],
        "RightVentSprites": [
            "Rooms/Right_Vent/LuiginetteVent1",
            "Rooms/Right_Vent/NLuigiVent"
        ],
        "CeilingSprites": [
            "Rooms/Ceiling/ClipMask/NLuigiCeiling"
        ],
        "HallwaySprites": [
            "Rooms/Office/Monitor/Camera/Lnette1",
            "Rooms/Office/Monitor/Camera/Lnette3",
            "Rooms/Hallway/NLuigiHallway"
        ],
        "TurnOffFlashlightInHallwayWhen": 2,
        "DirMinMovement": 1,
        "DirMaxMovement": 4,
        "DirMinTimerMovement": 60.0,
        "DirMaxTimerMovement": 90.0
    },
    main.CUSTOMNIGHTID: {
        "TimerMovementMin": 250.0,
        "TimerMovementMax": 320.0,
        "AttackTimer": 4.5,
        "FlashlightCounterTimer": 0.5,
        "MaskCounterTimer": 0.5,
        "LeftVentPositionCount": 1,
        "RightVentPositionCount": 1,
        "CeilingPositionCount": 0,
        "HallwayPositionCount": 4,
        "LeftVentSprites": [
            "Rooms/Left_Vent/LuiginetteVent1",
            "Rooms/Left_Vent/NLuigiVent"
        ],
        "RightVentSprites": [
            "Rooms/Right_Vent/LuiginetteVent1",
            "Rooms/Right_Vent/NLuigiVent"
        ],
        "CeilingSprites": [
            "Rooms/Ceiling/ClipMask/NLuigiCeiling"
        ],
        "HallwaySprites": [
            "Rooms/Office/Monitor/Camera/Lnette1",
            "Rooms/Office/Monitor/Camera/Lnette2",
            "Rooms/Office/Monitor/Camera/Lnette3",
            "Rooms/Office/Monitor/Camera/Lnette4",
            "Rooms/Hallway/NLuigiHallway"
        ],
        "TurnOffFlashlightInHallwayWhen": 4,
        "DirMinMovement": 1,
        "DirMaxMovement": 5,
        "DirMinTimerMovement": 120.0,
        "DirMaxTimerMovement": 180.0
    },
    main.ENDLESSID: {
        "TimerMovementMin": 250.0,
        "TimerMovementMax": 320.0,
        "AttackTimer": 3.0,
        "FlashlightCounterTimer": 0.5,
        "MaskCounterTimer": 0.5,
        "LeftVentPositionCount": 1,
        "RightVentPositionCount": 1,
        "CeilingPositionCount": 0,
        "HallwayPositionCount": 4,
        "LeftVentSprites": [
            "Rooms/Left_Vent/LuiginetteVent1",
            "Rooms/Left_Vent/NLuigiVent"
        ],
        "RightVentSprites": [
            "Rooms/Right_Vent/LuiginetteVent1",
            "Rooms/Right_Vent/NLuigiVent"
        ],
        "CeilingSprites": [
            "Rooms/Ceiling/ClipMask/NLuigiCeiling"
        ],
        "HallwaySprites": [
            "Rooms/Office/Monitor/Camera/Lnette1",
            "Rooms/Office/Monitor/Camera/Lnette2",
            "Rooms/Office/Monitor/Camera/Lnette3",
            "Rooms/Office/Monitor/Camera/Lnette4",
            "Rooms/Hallway/NLuigiHallway"
        ],
        "TurnOffFlashlightInHallwayWhen": 4,
        "DirMinMovement": 1,
        "DirMaxMovement": 5,
        "DirMinTimerMovement": 120.0,
        "DirMaxTimerMovement": 180.0
    },
}

var modifiers_descriptions: Dictionary[String, String] = {
    "AGGRESSIVE": "The characters will move 1.05x as fast.",
    "VISION": "The entire room will be dark, and you'll only be able to see by the light of a small flashlight.",
    "FLASHLIGHT": "The main flashlight will have limited battery life.",
    "SLOWNIGHTS": "The night will last longer, from 6 minutes to 8 minutes.",
}

#functions
func _ready() -> void:
    _load();
    _apply_settings();

func _get_input_as_array() -> Array[String]:
    return ["FLASHLIGHT", "MASK", "PAUSE"];

func _get_ai_level_as_array() -> Array[String]:
    return ["Nightmare Toy Sonic", "Nightmare Toy Mario",
    "Nightmare Toy Yoshi", "Nightmare Taingle", "Nightmare BT", "Nightmare S. Sonic",
    "Nightmare Cream", "Nightmare Knuckles", "Tails Doll",
    "Nightmare Luiginette"];

func _get_challenges_as_array() -> Array[String]:
    return ["Custom Night", "4/20", "Nintendon't", "Nintendo Power", "Sonic VS. Mario",
    "Friendly Fire", "Sidekick Hangout", "Night Shift in Company", "Panda Mode",
    "Advance 3", "Your Biggest Nightmare", "Grand Re-Opening",
    "Hammer Heartbreak II"];

func _save() -> void:
    var file: FileAccess = FileAccess.open_encrypted_with_pass(SAVE_DATA_PATH, FileAccess.WRITE, SAVE_DATA_PASSWORD);
    
    var data_to_save: Dictionary[String, Variant] = {
        "intro_cutscene_seen": save_data_file.introscenewatched,
        "night_2_play": save_data_file.night_to_play,
        "guide_unlocked": save_data_file.guideunlocked,
        "texture_filtering": save_data_file.texture_filtering,
        "window_mode": save_data_file.windowmode,
        "resolution": save_data_file.resolution,
        "v_sync": save_data_file.vsync,
        "fps_cap": save_data_file.fpscap,
        "input": save_data_file.keys,
        "master_volume": save_data_file.master_volume,
        "music_volume": save_data_file.music_volume,
        "sounds_volume": save_data_file.sounds_volume,
        "jumpscare_volume": save_data_file.jumpscares_volume,
        "fps_counter": save_data_file.fps_counter,
        "night_5_ending": save_data_file.night5ending,
        "night_6_ending": save_data_file.night6ending,
        "custom_night_challenges": save_data_file.custom_night_challenges,
        "night_7_ending": save_data_file.night7ending,
        "seen_ending": save_data_file.seen_ending,
        "max_mode_with_modifiers": save_data_file.max_mode_with_modifiers,
        "aggressive_mode": save_data_file.aggressive_mode,
        "limited_vision": save_data_file.limited_vision,
        "limited_flashlight": save_data_file.limited_flashlight,
        "slower_nights": save_data_file.slower_nights,
        "endless_mode_highscore_score": save_data_file.endless_mode_highscore_score,
        "endless_mode_highscore_hours": save_data_file.endless_mode_highscore_hours,
        "endless_mode_completed": save_data_file.endless_mode_completed,
        "saved_screenshots": save_data_file.saved_screenshots,
    }
    
    var data_to_json: String = JSON.stringify(data_to_save);

    file.store_string(data_to_json);
    file.close();

func _load() -> void:
    if FileAccess.file_exists(SAVE_DATA_PATH):
        var file: FileAccess = FileAccess.open_encrypted_with_pass(SAVE_DATA_PATH, FileAccess.READ, SAVE_DATA_PASSWORD);
        var data: Variant = JSON.parse_string(file.get_as_text());
        
        file.close();

        save_data_file = SaveDataResource.new();

        save_data_file.introscenewatched = data.intro_cutscene_seen;
        save_data_file.night_to_play = data.night_2_play;
        save_data_file.guideunlocked = data.guide_unlocked;

        save_data_file.texture_filtering = data.texture_filtering;

        save_data_file.windowmode = data.window_mode;
        save_data_file.resolution = data.resolution;
        save_data_file.vsync = data.v_sync;
        save_data_file.fpscap = data.fps_cap;
        
        for i in range(_get_input_as_array().size()):
            save_data_file.keys[_get_input_as_array()[i]] = data.input[_get_input_as_array()[i]];

        save_data_file.master_volume = data.master_volume;
        save_data_file.music_volume = data.music_volume;
        save_data_file.sounds_volume = data.sounds_volume;
        save_data_file.jumpscares_volume = data.jumpscare_volume;

        save_data_file.fps_counter = data.fps_counter;

        save_data_file.night5ending = data.night_5_ending;
        save_data_file.night6ending = data.night_6_ending;

        for i in range(_get_challenges_as_array().size()):
            if _get_challenges_as_array()[i] != "Custom Night":
                save_data_file.custom_night_challenges[_get_challenges_as_array()[i]] = data.custom_night_challenges[_get_challenges_as_array()[i]];

        save_data_file.night7ending = data.night_7_ending;
        save_data_file.seen_ending = data.seen_ending;
        save_data_file.max_mode_with_modifiers = data.max_mode_with_modifiers;

        save_data_file.aggressive_mode = data.aggressive_mode;
        save_data_file.limited_vision = data.limited_vision;
        save_data_file.limited_flashlight = data.limited_flashlight;
        save_data_file.slower_nights = data.slower_nights;

        save_data_file.endless_mode_highscore_score = data.endless_mode_highscore_score;
        save_data_file.endless_mode_highscore_hours = data.endless_mode_highscore_hours;

        save_data_file.endless_mode_completed = data.endless_mode_completed;

        save_data_file.saved_screenshots = data.saved_screenshots;

        print(data);
        
func _apply_settings() -> void:
    match (save_data_file.texture_filtering):
        0:
            get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR;
        1:
            get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST;

    match (save_data_file.windowmode):
        0:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
        1:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
        2:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
        
    match (save_data_file.resolution):
        0:
            DisplayServer.window_set_size(Vector2(640, 360), 0);
        1:
            DisplayServer.window_set_size(Vector2(1280, 720), 0);
        2:
            DisplayServer.window_set_size(Vector2(1920, 1080), 0);
    
    @warning_ignore("integer_division")
    var center_screen: Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2;
    var window_size: Vector2i = get_window().get_size_with_decorations()
    @warning_ignore("integer_division")
    var new_window_position: Vector2i = center_screen - window_size / 2;
    get_window().set_position(new_window_position);
    
    match (save_data_file.vsync):
        false:
            DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED);
        true:
            DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED);
            
    match (save_data_file.fpscap):
        0:
            Engine.max_fps = 30;
        1:
            Engine.max_fps = 60;
        2:
            Engine.max_fps = 120;
        3:
            Engine.max_fps = 0;

    var mask_input_key: InputEvent = InputEventKey.new();
    var flash_input_key: InputEvent = InputEventKey.new();
    var pause_input_key: InputEvent = InputEventKey.new();

    flash_input_key.keycode = save_data_file.keys["FLASHLIGHT"];
    mask_input_key.keycode = save_data_file.keys["MASK"];
    pause_input_key.keycode = save_data_file.keys["PAUSE"];

    InputMap.action_erase_events("FLASHLIGHT");
    InputMap.action_add_event("FLASHLIGHT", flash_input_key);

    InputMap.action_erase_events("MASK");
    InputMap.action_add_event("MASK", mask_input_key);

    InputMap.action_erase_events("PAUSE");
    InputMap.action_add_event("PAUSE", pause_input_key);
    
    AudioServer.set_bus_volume_linear(0, save_data_file.master_volume);
    AudioServer.set_bus_volume_linear(1, save_data_file.music_volume);
    AudioServer.set_bus_volume_linear(2, save_data_file.sounds_volume);
    AudioServer.set_bus_volume_linear(3, save_data_file.jumpscares_volume);
    
    match (save_data_file.fps_counter):
        false:
            FpsCounter.get_node("MarginContainer").hide();
        true:
            FpsCounter.get_node("MarginContainer").show();

func _reset_ai() -> void:
    for i in range(_get_ai_level_as_array().size()):
        ai_levels[_get_ai_level_as_array()[i]] = AIDEFAULTLEVEL;
    print(ai_levels);

func _set_min_ai() -> void:
    for i in range(_get_ai_level_as_array().size()):
        ai_levels[_get_ai_level_as_array()[i]] = AIMINVALUE;