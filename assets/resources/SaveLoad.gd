class_name SaveDataResource extends Resource

#variables to save and load
@export var introscenewatched: bool = false;
@export var night_to_play: int = 1; # campaign only
@export var guideunlocked: bool = false;

@export var texture_filtering: int = 0;

@export var windowmode: int = 0;
@export var resolution: int = 1;
@export var vsync: bool = true;
@export var fpscap: int = 1;

@export var keys: Dictionary[String, Key] = {
    "FLASHLIGHT": KEY_CTRL,
    "MASK": KEY_SHIFT,
    "PAUSE": KEY_ESCAPE
};

@export var master_volume: float = 1;
@export var music_volume: float = 1;
@export var sounds_volume: float = 1;
@export var jumpscares_volume: float = 1;

@export var fps_counter: bool = false;

@export var night5ending: bool = false;
@export var night6ending: bool = false;

@export var custom_night_challenges: Dictionary[String, bool] = {
    "4/20": false,
    "Nintendon't": false,
    "Nintendo Power": false,
    "Sonic VS. Mario": false,
    "Friendly Fire": false,
    "Sidekick Hangout": false,
    "Night Shift in Company": false,
    "Panda Mode": false,
    "Advance 3": false,
    "Your Biggest Nightmare": false,
    "Grand Re-Opening": false,
    "Hammer Heartbreak II": false,
}

@export var night7ending: bool = false;
@export var seen_ending: bool = false;
@export var max_mode_with_modifiers: bool = false;

@export var aggressive_mode: bool = false;
@export var limited_vision: bool = false;
@export var limited_flashlight: bool = false;
@export var slower_nights: bool = false;

@export var endless_mode_highscore_score: int = 0;
@export var endless_mode_highscore_hours: int = 0;

@export var endless_mode_completed: bool = false;

@export var saved_screenshots: int = 1;