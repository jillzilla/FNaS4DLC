extends Control

#variables
@onready var video_settings : ScrollContainer = $MarginContainer/Video;
@onready var audio_settings : ScrollContainer = $MarginContainer/Audio;
@onready var misc_settings : ScrollContainer = $MarginContainer/Misc;

@onready var windowed_mode_button : OptionButton = $MarginContainer/Video/VideoContainer/WindowMode/OptionButton;
@onready var resolution_button : OptionButton = $MarginContainer/Video/VideoContainer/Resolution/OptionButton;
@onready var vsync_button : CheckBox = $MarginContainer/Video/VideoContainer/VSync/CheckBox;
@onready var fpscap_button : OptionButton = $MarginContainer/Video/VideoContainer/FPSCap/OptionButton;

@onready var mastervolume_slider : HSlider = $MarginContainer/Audio/AudioContainer/MasterVolume/HSlider;
@onready var musicvolume_slider : HSlider = $MarginContainer/Audio/AudioContainer/MusicVolume/HSlider;
@onready var soundsvolume_slider : HSlider = $MarginContainer/Audio/AudioContainer/SoundsVolume/HSlider;
@onready var jumpscarevolume_slider : HSlider = $MarginContainer/Audio/AudioContainer/JumpscareVolume/HSlider;

@onready var fps_counter : CheckBox = $MarginContainer/Misc/MiscContainer/FPSCounter/CheckBox;

@onready var confirm_popup : Control = $ConfirmPopUp;

var resetdata : bool = false;
var deletedata : bool = false;

#functions
func _ready() -> void:
	confirm_popup.connect("confirmaction", _confirmed_action);
	_sync_button_with_options();

func _sync_button_with_options() -> void:
	windowed_mode_button.selected = main.windowmode;
	resolution_button.selected = main.resolution;
	vsync_button.button_pressed = main.vsync;
	fpscap_button.selected = main.fpscap;
	
	mastervolume_slider.value = main.master_volume;
	musicvolume_slider.value = main.music_volume;
	soundsvolume_slider.value = main.sounds_volume;
	jumpscarevolume_slider.value = main.jumpscares_volume;
	
	fps_counter.button_pressed = main.fps_counter;

func _on_apply_pressed() -> void:
	self.hide();
	
	main._apply_settings();
	main._save_game();

func _on_video_pressed() -> void:
	video_settings.show();
	audio_settings.hide();
	misc_settings.hide();

func _on_audio_pressed() -> void:
	video_settings.hide();
	audio_settings.show();
	misc_settings.hide();

func _on_misc_pressed() -> void:
	video_settings.hide();
	audio_settings.hide();
	misc_settings.show();

func _on_windowmode_item_selected(index: int) -> void:
	main.windowmode = index;

func _on_resolution_item_selected(index: int) -> void:
	main.resolution = index;

func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	main.vsync = toggled_on;

func _on_fpscap_item_selected(index: int) -> void:
	main.fpscap = index;

func _on_mastah_value_changed(value: float) -> void:
	main.master_volume = value;

func _on_moosic_value_changed(value: float) -> void:
	main.music_volume = value;

func _on_sounds_value_changed(value: float) -> void:
	main.sounds_volume = value;

func _on_jumpscares_value_changed(value: float) -> void:
	main.jumpscares_volume = value;

func _on_fps_counter_toggled(toggled_on: bool) -> void:
	main.fps_counter = toggled_on;

func _on_resetsettings_pressed() -> void:
	resetdata = true;
	deletedata = false;
	confirm_popup.show();

func _on_deletedata_pressed() -> void:
	deletedata = true;
	resetdata = false;
	confirm_popup.show();

func _reset_settings() -> void:
	main.windowmode = main.DEFAULT_WINDOW_MODE;
	main.resolution = main.DEFAULT_RESOLUTION;
	main.vsync = main.DEFAULT_VSYNC;
	main.fpscap = main.DEFAULT_FPSCAP;
	
	main.master_volume = main.DEFAULT_MASTER_VOLUME;
	main.music_volume = main.DEFAULT_MUSIC_VOLUME;
	main.sounds_volume = main.DEFAULT_SOUNDS_VOLUME;
	main.jumpscares_volume = main.DEFAULT_JUMPSCARE_VOLUME;
	
	main.fps_counter = main.DEFAULT_FPSCOUNTER;

func _confirmed_action() -> void:
	if resetdata:
		_reset_settings();
		_sync_button_with_options();
	elif deletedata:
		if get_tree().paused:
			get_tree().paused = false;
		DirAccess.remove_absolute(main.SAVE_DATA_PATH);
		_reset_settings();
		main._save_game();
		main._apply_settings();
		get_tree().change_scene_to_file("res://assets/scenes/intro.tscn");
