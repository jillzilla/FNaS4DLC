extends Node

#variables
@onready var characters_renders: Array[Sprite2D] = [$Control/Characters/CharactersTextures/ToySonic, $Control/Characters/CharactersTextures/ToyMario,
$Control/Characters/CharactersTextures/ToyYoshi, $Control/Characters/CharactersTextures/Taingle, $Control/Characters/CharactersTextures/BalloonToad,
$Control/Characters/CharactersTextures/SalvageSonic, $Control/Characters/CharactersTextures/Cream, $Control/Characters/CharactersTextures/Knuckles,
$Control/Characters/CharactersTextures/TailsDoll, $Control/Characters/CharactersTextures/Luiginette];

@onready var characters_section: Control = $Control/Characters;
@onready var jumpscares_section: Control = $Control/Jumpscares;
@onready var old_nights: Control = $Control/OldNights;
@onready var loading: Control = $Loading;
@onready var character_name_label: Label = $Control/Characters/CharacterName;

var character_selected: int = 0;
var characters_names: Array[String] = ["Nightmare Toy Sonic", "Nightmare Toy Mario", "Nightmare Toy Yoshi", "Nightmare Taingle", "Nightmare Balloon Toad",
"Nightmare Salvage Sonic", "Nightmare Cream", "Nightmare Knuckles", "Tails Doll", "Nightmare Luiginette"];

#functions
func _ready() -> void:
	DiscordManager._update_details("Extras Content Menu");
	DiscordManager._update_state("");

func _on_back_pressed() -> void:
	loading._load_scene("uid://cl7jf3xdjegaf");

func _on_right_pressed() -> void:
	if characters_section.visible:
		character_selected += 1;
		if character_selected > characters_renders.size() - 1:
			character_selected = 0;
		_show_character();

func _on_left_pressed() -> void:
	if characters_section.visible:
		character_selected -= 1;
		if character_selected < 0:
			character_selected = characters_renders.size() - 1;
		_show_character();

func _show_character() -> void:
	character_name_label.text = characters_names[character_selected];
	for c in characters_renders:
		c.hide();
	characters_renders[character_selected].show();

func _on_chars_pressed() -> void:
	characters_section.show();
	jumpscares_section.hide();
	old_nights.hide();

func _on_jumpscares_pressed() -> void:
	characters_section.hide();
	jumpscares_section.show();
	old_nights.hide();

func _on_old_nights_pressed() -> void:
	characters_section.hide();
	jumpscares_section.hide();
	old_nights.show();

func _on_night_1_pressed() -> void:
	main.nightcounter = 1;
	loading._load_scene("uid://bocmtkamvkla5");

func _on_night_2_pressed() -> void:
	main.nightcounter = 2;
	loading._load_scene("uid://bocmtkamvkla5");

func _on_night_3_pressed() -> void:
	main.nightcounter = 3;
	loading._load_scene("uid://bocmtkamvkla5");

func _on_night_4_pressed() -> void:
	main.nightcounter = 4;
	loading._load_scene("uid://bocmtkamvkla5");