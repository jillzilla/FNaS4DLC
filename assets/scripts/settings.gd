extends Control

#variables
@onready var video_settings: ScrollContainer = $MarginContainer/Video;
@onready var input_settings: ScrollContainer = $MarginContainer/Input;
@onready var audio_settings: ScrollContainer = $MarginContainer/Audio;
@onready var misc_settings: ScrollContainer = $MarginContainer/Misc;

@onready var windowed_mode_button: OptionButton = $MarginContainer/Video/VideoContainer/WindowMode/OptionButton;
@onready var resolution_button: OptionButton = $MarginContainer/Video/VideoContainer/Resolution/OptionButton;
@onready var vsync_button: CheckBox = $MarginContainer/Video/VideoContainer/VSync/CheckBox;
@onready var fpscap_button: OptionButton = $MarginContainer/Video/VideoContainer/FPSCap/OptionButton;

@onready var flashlight_key_button: Button = $MarginContainer/Input/InputContainer/Flashlight/Button;
@onready var mask_key_button: Button = $MarginContainer/Input/InputContainer/Mask/Button;
@onready var pause_key_button: Button = $MarginContainer/Input/InputContainer/Pause/Button;

@onready var mastervolume_slider: HSlider = $MarginContainer/Audio/AudioContainer/MasterVolume/HSlider;
@onready var musicvolume_slider: HSlider = $MarginContainer/Audio/AudioContainer/MusicVolume/HSlider;
@onready var soundsvolume_slider: HSlider = $MarginContainer/Audio/AudioContainer/SoundsVolume/HSlider;
@onready var jumpscarevolume_slider: HSlider = $MarginContainer/Audio/AudioContainer/JumpscareVolume/HSlider;

@onready var fps_counter: CheckBox = $MarginContainer/Misc/MiscContainer/FPSCounter/CheckBox;

@onready var confirm_popup: Control = $ConfirmPopUp;

var resetdata: bool = false;
var deletedata: bool = false;

#functions
func _ready() -> void:
	confirm_popup.connect("confirmaction", _confirmed_action);
	_sync_button_with_options();

func _sync_button_with_options() -> void:
	windowed_mode_button.selected = main.save_data_file.windowmode;
	resolution_button.selected = main.save_data_file.resolution;
	vsync_button.button_pressed = main.save_data_file.vsync;
	fpscap_button.selected = main.save_data_file.fpscap;

	flashlight_key_button._update_text();
	mask_key_button._update_text();
	pause_key_button._update_text();
	
	mastervolume_slider.value = main.save_data_file.master_volume;
	musicvolume_slider.value = main.save_data_file.music_volume;
	soundsvolume_slider.value = main.save_data_file.sounds_volume;
	jumpscarevolume_slider.value = main.save_data_file.jumpscares_volume;
	
	fps_counter.button_pressed = main.save_data_file.fps_counter;

func _on_apply_pressed() -> void:
	self.hide();

	video_settings.hide();
	input_settings.hide();
	audio_settings.hide();
	misc_settings.hide();

	main._save();
	main._apply_settings();

func _on_video_pressed() -> void:
	video_settings.show();
	input_settings.hide();
	audio_settings.hide();
	misc_settings.hide();

func _on_input_pressed() -> void:
	video_settings.hide();
	input_settings.show();
	audio_settings.hide();
	misc_settings.hide();

func _on_audio_pressed() -> void:
	video_settings.hide();
	input_settings.hide();
	audio_settings.show();
	misc_settings.hide();

func _on_misc_pressed() -> void:
	video_settings.hide();
	input_settings.hide();
	audio_settings.hide();
	misc_settings.show();

func _on_windowmode_item_selected(index: int) -> void:
	main.save_data_file.windowmode = index;

func _on_resolution_item_selected(index: int) -> void:
	main.save_data_file.resolution = index;

func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	main.save_data_file.vsync = toggled_on;

func _on_fpscap_item_selected(index: int) -> void:
	main.save_data_file.fpscap = index;

func _on_mastah_value_changed(value: float) -> void:
	main.save_data_file.master_volume = value;

func _on_moosic_value_changed(value: float) -> void:
	main.save_data_file.music_volume = value;

func _on_sounds_value_changed(value: float) -> void:
	main.save_data_file.sounds_volume = value;

func _on_jumpscares_value_changed(value: float) -> void:
	main.save_data_file.jumpscares_volume = value;

func _on_fps_counter_toggled(toggled_on: bool) -> void:
	main.save_data_file.fps_counter = toggled_on;

func _on_resetsettings_pressed() -> void:
	resetdata = true;
	deletedata = false;
	confirm_popup.show();

func _on_deletedata_pressed() -> void:
	deletedata = true;
	resetdata = false;
	confirm_popup.show();

func _reset_settings() -> void:
	main.save_data_file.windowmode = 0;
	main.save_data_file.resolution = 1;
	main.save_data_file.vsync = true;
	main.save_data_file.fpscap = 1;

	main.save_data_file.keys["FLASHLIGHT"] = KEY_CTRL;
	main.save_data_file.keys["MASK"] = KEY_SHIFT;
	main.save_data_file.keys["PAUSE"] = KEY_ESCAPE;
	
	main.save_data_file.master_volume = 1;
	main.save_data_file.music_volume = 1;
	main.save_data_file.sounds_volume = 1;
	main.save_data_file.jumpscares_volume = 1;
	
	main.save_data_file.fps_counter = false;

func _confirmed_action() -> void:
	if resetdata:
		_reset_settings();
		_sync_button_with_options();
	elif deletedata:
		if FileAccess.file_exists(main.SAVE_DATA_PATH):
			DirAccess.remove_absolute(main.SAVE_DATA_PATH);
		OS.alert("Save file successfully deleted. Reload the game to apply the settings.", "Five Nights at Sonic's 4 DLC")
		get_tree().quit();