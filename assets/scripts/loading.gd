extends Control

signal scene_loaded;

#variables
@onready var counter : Label = $Label;
var scene_path : String = "";
var scene_loading : bool = false;
var scene_to_be_loaded : PackedScene = null;

#functions
func _load_scene(scene: String) -> void:
	if scene:
		main.isloadingsom = true;
		self.show();
		scene_path = scene;
		ResourceLoader.load_threaded_request(scene_path);
		scene_loading = true;

func _process(_delta: float) -> void:
	if scene_loading:
		var progress : Array[float] = [];
		var status := ResourceLoader.load_threaded_get_status(scene_path,progress);
		
		if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			scene_to_be_loaded = ResourceLoader.load_threaded_get(scene_path);
			scene_loading = false;
			scene_loaded.emit();
			main.isloadingsom = false;
