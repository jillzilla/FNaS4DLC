extends Control

#variables
@onready var salvage: TextureButton = $Buttons/GridContainer/SS;
@onready var cream: TextureButton = $Buttons/GridContainer/Cream;
@onready var luiginette: TextureButton = $Buttons/GridContainer/Luiginette;
@onready var tailsdoll: TextureButton = $Buttons/GridContainer/TailsDoll;
@onready var knuckles: TextureButton = $Buttons/GridContainer/Knuckles;

#functions
func _ready() -> void:
	_update_icon_visibility();
		
func _on_back_pressed() -> void:
	hide();

func _update_icon_visibility() -> void:
	if main.save_data_file.night_to_play >= 3: salvage.show();
	if main.save_data_file.night_to_play >= 4: cream.show();
	if main.save_data_file.night_to_play >= 5: luiginette.show();
	if main.save_data_file.night6ending:
		tailsdoll.show();
		knuckles.show();